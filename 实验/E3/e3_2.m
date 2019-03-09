clc,clear
%load data
x=load('ex5Logx.dat');
y=load('ex5Logy.dat');
m=length(x);
lambdas=[0 1 10];
epsilon=10^-6;%error
lambda=1;
iter=0;
max_iters=1000;

pos=find(y==1);%admitted
neg=find(y==0);%not admitted
%plot data
plot(x(pos, 1), x(pos, 2),'b+');
hold on;
plot(x(neg, 1), x(neg, 2),'ro');
%legend('Admitted','Not Admitted');

g=@(z)1./(1+exp(-z));%sigmod function
x=map_feature(x(:,1),x(:,2));
n=size(x,2);
theta=zeros(n,1);
delte0=zeros(1,1);
delte=zeros(n,1);
J=zeros(max_iters,1);
H=zeros(n,n);
T=eye(n,n);
T(1)=0;
z=x*theta;
%the first iteration
iter=iter+2;
J(1)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) )+lambda*sum(theta.^2)/(2*m);
for i=1:m
    delte0=delte0+( g(z(i))-y(i) )/m;
    delte=delte+( g(z(i))-y(i) ).*x(i,:)'/m;
    H=H+g(z(i)).*(1-g(z(i))).*(x(i,:)'*x(i,:))/m;
end
delte(1)=delte0;
theta=theta-inv(H+lambda*T/m)*(delte+lambda*theta/m);   
z=x*theta;
J(2)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) )+lambda*sum(theta.^2)/(2*m);


while(abs(J(iter)-J(iter-1))>=epsilon&&iter<=max_iters)
    iter=iter+1;
    delte0=zeros(1,1);
    delte=zeros(n,1);
    H=zeros(n,n);
    for i=1:m
        delte0=delte0+( g(z(i))-y(i) )/m;
        delte=delte+( g(z(i))-y(i) ).*x(i,:)'./m;
        H=H+g(z(i)).*(1-g(z(i))).*(x(i,:)'*x(i,:))./m;
    end  
    delte(1)=delte0;
    theta=theta-inv(H+lambda*T/m)*(delte+lambda*theta/m);
    z=x*theta;
    J(iter)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) )+lambda*sum(theta.^2)/(2*m);
end




hold on;
% Define the ranges of the grid
u = linspace(-1, 1.5 , 200);
v = linspace(-1, 1.5 , 200);
% I n i t i a l i z e space for the values to be plotted
z = zeros(length(u) , length(v ));
% Evaluate z = theta?x over the grid
for i = 1: length(u)
for j = 1: length(v)
% Notice the order of j , i here !
z( i , j ) = map_feature (u( i ) , v( j ))* theta ;
end
end
% Because of the way that contour plotting works
% in Matlab , we need to transpose z , or
% else the axis orientation will be flipped !
z = z';
% Plot z = 0 by specifying the range [0 , 0]
contour(u ,v , z , [0 , 0] ,'k:', 'LineWidth' , 2)
xlabel('\lambda=0');

iter_2=iter+1;
while(iter_2<=max_iters)
    J(iter_2)=J(iter);
    iter_2=iter_2+1;
end
figure;
plot([1:15],J([1:15],:),'-');
xlabel('iteration'),ylabel('L(\theta)');



