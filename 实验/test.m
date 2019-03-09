clc,clear;
%load data
x=load('ex4x.dat');
y=load('ex4y.dat');
m=length(x);
n=size(x,2)+1;
theta=zeros(n,1);
alpha=0.0022;%learning rate
epsilon=10^-6;%error
iter=0;

%add x_0
x=[ones(m,1) x];
%{
sigma = std(x );
mu = mean(x );
sigma = std(x );
mu = mean(x );
x (: ,2) = (x (: ,2) - mu(2))./ sigma (2);
x (: ,3) = (x (: ,3) - mu(3))./ sigma (3);
%}
pos=find(y==1);%admitted
neg=find(y==0);%not admitted

%plot data
plot(x(pos, 2), x(pos, 3),'+')
hold on;
plot(x(neg, 2), x(neg, 3),'o')