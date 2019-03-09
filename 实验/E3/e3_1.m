clc,clear;
%load data
x=load('ex5Linx.dat');
y=load('ex5Liny.dat');
m=length(x);
lambdas=[0 1 10 100];

plot(x,y,'o','MarkerFaceColor','r');
%xlabel('Age in years'),ylabel('Height in meters');

x=[ones(m,1),x,x.^2,x.^3,x.^4,x.^5];
n=size(x,2);
theta=zeros(n,1);
T=eye(n,n);
T(1)=0;

for ii=1:size(lambdas,2)

    lambda=lambdas(ii);
    theta=inv(x'*x+lambda*T)*x'*y;
    
    hold on;
    tempx=-1:.01:1;
    tempa=theta';
    plot(tempx,polyval(tempa(:,6:-1:1),tempx),'--');%A(:, [j2:-1:j1]) 

end
legend('traing data','\lambda=0','\lambda=1','\lambda=10','\lambda=100');

