function res=nlfun(beta,x)
b1 = beta(1);
b2 = beta(2);
b3 = beta(3);
x1=x(:,1);
x2=x(:,2);
res = exp(b1*x1+b2*x2+b3);
