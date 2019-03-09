clc,clear
x=load('ex2x.dat');
y=load('ex2y.dat');
sigma = std ( x ) ;
mu = mean( x ) ;
m=length(y);
n=size(x,2)+1;
for i=1:m%数据处理
    x(i,:)=(x(i,:)-mu)./sigma;
end
x = [ones(m, 1) x];
theta = zeros ( size ( x ( 1 , : ) ) )' ; % initialize fitting parameters
alpha =0.15; % Your initial learning rate 
J = zeros (50 , 1 ) ;
iterations = 50;%设置迭代次数

for num_iterations = 1:50
    H=x*theta;
    T=zeros(n,1);
    for i=1:m
        T=T+(H(i)-y(i))*x(i,:)';
    end
J ( num_iterations ) =sum((x*theta - y).^2)/(2*m); % 成本函数 
theta = theta-alpha*T/m;% 梯度下降更新 
end
% now plot J
% technically , the first J starts at the zero-eth iteration
% but Matlab/Octave doesn ' t have a zero index
figure ;
plot ( 0 : 49 , J ( 1 : 50 ) , '-' )
xlabel ( 'Number of iterations ' )
ylabel ( ' Cost J ' )
