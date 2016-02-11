function model
clear
n=5;m=4; etime=n*m*2;lamb=1/20;
dyns=[];stas=[];egain=[];
pv=findpolyfunc(etime,0);
pr=findpolyfunc4resist(etime);

b=1.09;L=etime;k=1.3; I=k*0.01; %k is A per cell
%energy
for t=0:etime%N=0:n*m%
    yv=polyval(pv,t);
    %yr=polyval(pr,t);
    N=round(n*m*(1-exp(-lamb*t)));
    if N <=n*m
        dyns=[dyns (yv*I^b*(L-t))*(n-ceil(N/m))];
    else
        dyns=[dyns 0];
    end;
    if N <= n  
        stas=[stas (yv*I^b*(L-t))*(n-N)];
    else
        stas=[stas 0];
    end
    
    if N <=n
        egain=[egain (yv*I^b*(L-t))*(N-ceil(N/m))];
    elseif n <N <=n*m
        egain=[egain (yv*I^b*(L-t))*(n-ceil(N/m))];
    else
        egain=[egain 0];
    end
end
figure %energy
x= [0:etime];%[0:1/(n*m):1];
plot(x,dyns,'--',x,stas,'-.','LineWidth',2);
figure
plot(x,egain,'-','LineWidth',2);

% Gain
I=0.02; %mA
m=100; %series
n=100; %parallel
LG=zeros(m,n);
AG=zeros(m,n);
for j=1:n
    for i=1:m
        LG(i,j)=(2*i^2*n*I*5)/(i-1)*(((j-1)*i^2+i*j-(j-1))*I^b);
        AG(i,j)=((m*n+1)*k)/((3/2+m*n/2)*I^b);
        %G(m,n)=I^b*L*(1/lamb*(n+1/m-1)*log(1-n)-1/(m*lamb)*exp(-L*lamb)+1/m*(n/lamb-L)+n*(L-1/lamb));
    end
end
figure
%surface(LG);
%bar3(LG,0.25,'detached');
mesh(LG);
%shading faceted
figure
plot([1:n],AG(5,:),'-',[1:n],AG(10,:),'.-',[1:n],AG(15,:));
