clc,clear;
%load data
x=load('ex3Linx.dat');
y=load('ex3Liny.dat');
m=length(x);
alpha=0.1;%learning rate
%0 0.87;1 
lambdas=[0 1 10];
lambda=0;
epsilon=10^-15;%error
iter=0;
max_iters=100000;
J=zeros(max_iters,1);

plot(x,y,'o','MarkerFaceColor','r');
xlabel('Age in years'),ylabel('Height in meters');

x=[ones(m,1),x,x.^2,x.^3,x.^4,x.^5];
n=size(x,2);
for ii=3:3
    theta=zeros(n,1);
    T=zeros(n,1);
    T0=zeros(1,1);
    H=x*theta;

    lambda=lambdas(ii);
    J(1)=1/(2*m)*(sum((x*theta - y).^2)+lambda*sum(theta.^2));
    iter=iter+2;
    for i=1:m
        T0=T0+(H(i)-y(i));
        T=T+(H(i)-y(i))*x(i,:)';
    end  
    T(1)=T0;
    theta=theta*(1-alpha*lambda/m)-alpha*T/m;
    %theta(1)=theta(1)-alpha*T0/m;
    H=x*theta;
    J(2)=1/(2*m)*(sum((x*theta - y).^2)+lambda*sum(theta.^2));


    %abs(L(iter+1)-L(iter))>=epsilon&&epsilon&&iter<=max_iter
    while(abs(J(iter)-J(iter-1))>=epsilon&&iter<=max_iters)
        iter=iter+1;
        T=zeros(n,1);
        T0=zeros(1,1);
        for i=1:m
            T0=T0+(H(i)-y(i));
            T=T+((H(i))-y(i))*x(i,:)';
        end
        T(1)=T0;
        theta=theta*(1-alpha*lambda/m)-alpha*T/m;
        %theta(1)=theta(1)-alpha*T0/m;
        H=x*theta;
        J(iter)=1/(2*m)*(sum((x*theta - y).^2)+lambda*sum(theta.^2));
    end
    
    hold on;
    tempx=-1:.01:1;
    tempa=theta';
    plot(tempx,polyval(tempa(:,6:-1:1),tempx),'--');%A(:, [j2:-1:j1]) 

end
%legend('sorc','\lambda=0','\lambda=1','\lambda=10');

