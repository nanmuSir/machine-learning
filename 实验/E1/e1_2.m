clc,clear;
x=load('ex2x.dat');
y=load('ex2y.dat');
sigma=std(x);%求各列的标准差
mu=mean(x);%求各列的平均值
%alpha=1.2;%设置初始学习值
iterations = 50;%设置迭代次数
m=length(y);
for i=1:m%数据处理
    x(i,:)=(x(i,:)-mu)./sigma;
end
x=[ones(m,1),x];
theta=zeros(size(x,2),1);

alpha=0.9;%设置初始学习值
for num_iterations = 1:iterations
    grad = (1/m).* x' * ((x * theta) - y);
    theta = theta - alpha .* grad;
end
%plot
figure;
plot(0:(iterations-1),J,'-');
xlabel('Number of iterations'),ylabel('Cost J');



%{
hold on;
alpha=1.20;%设置初始学习值
theta=zeros(size(x,2),1);
[theta,J] = gradientDescent(x, y, theta, alpha, iterations);%start up
%plot
figure;
plot(0:(iterations-1),J,'-');
xlabel('Number of iterations'),ylabel('Cost J');
legend('\alpha=9');


hold on;
alpha=1.21;%再次设置初始学习值
theta=zeros(size(x,2),1);
[theta,J] = gradientDescent(x, y, theta, alpha, iterations);%start up
plot(0:(iterations-1),J,'-');

hold on;
alpha=1.22;%再次设置初始学习值
theta=zeros(size(x,2),1);
[theta,J] = gradientDescent(x, y, theta, alpha, iterations);%start up
plot(0:(iterations-1),J,'-');


legend('\alpha=0.1','\alpha=0.2','\alpha=0.3');
%}




%start up
