clc,clear;
x=load('ex1x.dat');
y=load('ex1y.dat');
alpha=0.07;%学习率
m=length(y);%样本个数
iterations=1500;%迭代次数

plot(x,y,'o');
xlabel('Age in years'),ylabel('Height in meters');
x=[ones(m,1),x];
theta=zeros(size(x,2),1);%参数向量

for num_iterations = 1:iterations
    grad = (1/m).* x' * ((x * theta) - y);
    theta = theta - alpha .* grad;
end

hold on;
plot(x(:,2),x*theta,'-');
legend('Training data','Linear regression');

%{
%visualize
J_vals=zeros(100,100); 
theta0_vals=linspace(-3,3,100);
theta1_vals=linspace(-1,1,100);
for i=1:length( theta0_vals)
    for j=1:length( theta1_vals)
        t = [theta0_vals(i);theta1_vals(j)];
        J_vals(i,j)=loss_function(x,y,t);
    end
end
J_vals=J_vals';
%surf plot
figure;
surf(theta0_vals,theta1_vals,J_vals);
xlabel('\theta_0'),ylabel('\theta_1'),zlabel('J(\theta)');


% Contour plot
figure;
contour(theta0_vals, theta1_vals, J_vals, logspace(-2, 3, 20));%x=logspace(a,b,n)生成有n个元素的对数等分行向量x，且x(1)=10的a次方，x(n)=10的b次方
xlabel('\theta_0'); ylabel('\theta_1');
hold on;
plot(theta(1), theta(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
%}