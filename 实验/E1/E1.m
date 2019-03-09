clc,clear
x=load('ex1x.dat');
y=load('ex1y.dat');
figure
plot(x,y,'o');
ylabel('Height in meter');
xlabel('Age in years');
m=length(y);
x=[ones(m,1),x];
theta = zeros(size(x(1,:)));
hx=x*theta';
theta(j)=theta(j)-alpha*1/m*symsum((theta'*x^i-y^i)*x^i);
hold on
plot(x(:,2),x*theta,'-');
legend('Traning data','Linear regression');
J_vals=zeros(100,100);
theta0_vals=linspace(-3,3,100);
theta1_vals=linspace(-1,1,100);
for i=1:length(theta1_vals)
    for j=1:length(theta1_vals)
        t=[theta0_vals(i);theta1_vals(j)];
        J_vals(i,j)=loss_function(x,y,t);
    end
end
J_vals=J_vals';
figure;
surf(theta0_vals,theta1_vals,J_vals)
xlabel('\theta_0');
ylabe('\theta_1');

