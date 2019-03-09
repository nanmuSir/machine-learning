clc,clear;
%load data
x=load('ex4x.dat');
y=load('ex4y.dat');
m=length(x);
n=size(x,2)+1;
theta=zeros(n,1);
epsilon=10^-6;
iter=0;

%add x_0
x=[ones(m,1) x];
%{
sigma = std(x );
mu = mean(x );
x (: ,2) = (x (: ,2) - mu(2))./ sigma (2);
x (: ,3) = (x (: ,3) - mu(3))./ sigma (3);
%}
pos=find(y==1);%admitted
neg=find(y==0);%not admitted

%plot data
plot(x(pos, 2), x(pos, 3),'+');
hold on;
plot(x(neg, 2), x(neg, 3),'o');
%legend('Admitted','Not Admitted');


max_iter=1000;
L=zeros(max_iter,1);
H=zeros(max_iter,1);
%g=inline('1/(1+exp(-z))');
g=@(z)1./(1+exp(-z));%sigmod function
delte=zeros(n,1);
H=zeros(n,n);
z=x*theta;
L(1)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) );

%the first iteration
iter=2;
for i=1:m
    delte=delte+( g(z(i))-y(i) )*x(i,:)'./m;
    H=H+g(z(i)).*(1-g(z(i))).*(x(i,:)'*x(i,:))./m;
end
theta=theta-inv(H)*delte;   
z=x*theta;
L(2)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) );


while(abs(L(iter)-L(iter-1))>=epsilon&&iter<=max_iter)
    iter=iter+1;
    delte=zeros(n,1);
    H=zeros(n,n);
    for i=1:m
        delte=delte+( g(z(i))-y(i) )*x(i,:)'./m;
        H=H+g(z(i)).*(1-g(z(i))).*(x(i,:)'*x(i,:))./m;
    end  
    theta=theta-inv(H)*delte;
    z=x*theta;
    L(iter)=-1/m*sum( y.*log(g(z))+(1-y).*log(1-g(z)) );
end

iter_2=iter+1;
while(iter_2<=max_iter)
    L(iter_2)=L(iter);
    iter_2=iter_2+1;
end

hold on;
x_axis = x(:,2);
y_axis = -(theta(1).*x(:,1)+theta(2).*x(:,2))/theta(3);
plot(x_axis, y_axis,'-');
legend('Admitted','Not Admitted','Linear regression');
xlabel('exam_1 score'),ylabel('exam_2 score');

figure;
plot([1:6],L([1:6],:),'-');
xlabel('iteration'),ylabel('L(\theta)');
