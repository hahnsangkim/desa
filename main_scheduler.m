function main_scheduler
clear all
%close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% battery characteristics
% returns coeff of RT1;RT2;RT10 based on Coulomb
coeff_re=calcul_coeff_re(1,100); %[p1; p2; p10] coulomb
% find max recovery efficiency
p=coeff_re(1,:); %coulomb
dep=polyder(p);
ddep=polyder(dep);
x=[0:0.00002:4];
ind=find(polyval(dep,x)<=0.000002 & polyval(dep,x)>=-0.000002);
maxreC=[];
for l=1:length(ind)
    if polyval(ddep,x(ind(l))) < 0 & x(ind(l)) > 0.5
        maxreC=[maxreC x(ind(l))]; %recovery rate
    end
end
%maxreC=[0.8261 2.0435];
%generate reference
refC=Vref('dat/dualfoil5C23.out'); %coulomb
[coeff]=calcul_coeff_volt_new(1,100,refC); %nothing to do with coulomb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters associated with scheduling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interval=60;%every x second(s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin: Profiling Load Demand
% Input: lb, ub, runtime, ptype
% Output: variable/constant loads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init: number of cells, nominal coulombs of each
max_cap=3602.7; %coulombs 3602.7
max_volt=4.06267;
ind=find(refC.sX<=0.0005);
cutoff_voltage=polyval(refC.p,refC.tX(ind(1))); % this is very important
%cutoff_voltage=2.50000;
nomcells=4;
bat_pack=[];

l_demand=0.8; %0.3C (= 23A/m2)
u_demand=100/23;   %~ 4C
max_demand=u_demand;
runtimeratio=1;
max_runtime=floor((max_cap*runtimeratio)*60/interval); %minute
load_demand=[];

util=[];%utilization log
% rand, const1, const2, const3
dis_type=[l_demand:1/23:u_demand];
%dis_type='rand';


%ave_deg=[];
%for ai=1:100
    
for cycle=dis_type
    if ischar(cycle)
        cycle=dis_type;
    end
    % Coulomb
    load_demand=generate_loads(cycle,l_demand,u_demand,max_runtime,...
        maxreC,nomcells,interval);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Battery pack
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    turn=0.05;% at 1C (23A/m2) at this point voltage steeply drops
    %check the following
    thres_g=turn*u_demand;%at 4C, voltage steeply drops percentage %u_demand/max_cap * nomcells;% 0.2: 
    shutdown=thres_g*turn*8; 
    dyn_thres=0; %if 1 then thres_g and shutdown vary with discharge rate

    bat_pack=[]; %battery pack

    batpack(1:nomcells)=max_cap;
    batvolt(1:nomcells)=max_volt;
    %batvolt(1:nomcells)=[max_volt max_volt max_volt  max_volt];%max_volt*0.90];
    %batpack(1:nomcells)=[max_cap max_cap max_cap  max_cap];%max_cap*0.90];
    name=['kRR';'1RR';'Seq';'nRR'];
    init(1:nomcells)=0;
    for i=1:length(name)
        bat_pack=[bat_pack struct('id',name(i,:),'bpack',batpack,...
            'bvolt',batvolt,'RE',init,'ldisch',init,'GH',find(batpack>thres_g*max_cap),...
            'GL',find(batpack<=thres_g*max_cap),'k',[],'thres_g',thres_g,'turn',turn,'status',0,...
            'max_cap',max_cap,'max_volt',max_volt,'cutoff_voltage',cutoff_voltage,...
            'refC',refC,'maxreC',maxreC,'shutdown',shutdown,'disconnect',i,...
            'soc_log',[],'volt_log',[],'ldiff_log',[],'vdiff_log',[],'load_log',[],'otime_log',0)];
    end

    listofsch=[1 2 3 4];
    %online procedure
    for i=1:max_runtime %second
        listofsch=[];
        for n=1:length(bat_pack)
            if bat_pack(n).disconnect~=0
                listofsch=[listofsch n];
            end
        end
        if isempty(listofsch)
            break;
        end

        %discharge scheduling
        bat_pack=battery_discharge_scheduling...
            (i,interval,bat_pack,listofsch,coeff,coeff_re,dyn_thres,load_demand(i));

        %charge scheduling
    end %for
    
    temp=[];
    for k=1:length(bat_pack)
        temp=[temp; (bat_pack(k).max_cap-mean(bat_pack(k).bpack))/bat_pack(k).max_cap];
    end
    util=[util temp];
end %for load

if 0
deg=[];
for k=1:length(bat_pack)
    for m=1:length(bat_pack)
        deg(k,m)=bat_pack(k).otime_log/bat_pack(m).otime_log;
    end
end
ave_deg(ai,:,:)=deg';

mdeg=mean(ave_deg);
L=mdeg-min(ave_deg);
U=max(ave_deg)-mdeg;

X=[];tm=[];
for kk=1:length(bat_pack)
    X(1,:,kk)=[kk-0.27 kk-0.09 kk+0.09 kk+0.27];
    tm=[tm; mdeg(1,:,kk)];
end    
tm=tm';
grid on
figure %opcompcst.fig
bar(tm);
ylabel('Operation-time gain','FontSize',12);xlabel('Scheduling mechanisms','FontSize',12);
legend('Comparison with kRR','comparison with 1RR','comparison with 1+1RR','comparison with nRR');
hold on
errorbar(X,mdeg,L,U,'xr');
hold off
grid off
end
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(dis_type)
    analyze_data(bat_pack,load_demand);
else
    figure
    plot(dis_type,util,'MarkerSize',4,'LineWidth',2);
    xlabel('Discharge rate','FontSize',12);ylabel('Utilization','FontSize',12);
    legend(bat_pack(1).id,bat_pack(2).id,bat_pack(3).id,bat_pack(4).id);
end