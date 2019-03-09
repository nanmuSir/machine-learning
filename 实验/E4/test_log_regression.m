function test_log_regression()
% 读入数据
X = load('ex2x.dat'); Y = load('ex2y.dat');
% X = load('data\\fourclass.txt');
% Y = load('data\\fourclasslabel.txt');
tic;
 [coeff, score, latent, tsquared, explained] =  pca(X);%PCA过程
toc;
X =score(:,1);%需要降到几维就去前k维作为结果
X = [ones(size(X, 1), 1) X];
% 用牛顿法计算 theta
[theta, ll] = log_regression(X ,Y);
% 绘制图像
m=size(X,1);
figure; hold on;
% plot(X(Y < 0, 2), X(Y < 0, 3), 'rx', 'linewidth', 2);
% plot(X(Y > 0, 2), X(Y > 0, 3), 'go', 'linewidth', 2);
% x1 = min(X(:,2)):.1:max(X(:,2));
% x2 = -(theta(1) / theta(3)) - (theta(2) / theta(3)) * x1;
% %x2 = -(theta(1) / theta(3)) - (theta(2) / theta(3)) * x1;
% plot(x1,x2, 'linewidth', 2);
% xlabel('x1');   ylabel('x2');
%--------------------------------------------------------------------------
% plot(X(Y < 1.5, 2), X(Y < 1.5, 3), 'rx', 'linewidth', 2);
% plot(X(Y > 1.5, 2), X(Y > 1.5, 3), 'go', 'linewidth', 2);
% x1 = min(X(:,2)):.1:max(X(:,2));
% x2 = -(theta(1) / theta(3)) - (theta(2) / theta(3)) * x1+log(3)/theta(3);
% x2 = -(theta(1) / theta(3)) - (theta(2) / theta(3)) * x1;
% plot(x1,x2, 'linewidth', 2);
% xlabel('x1');   ylabel('x2');
%------------------------------------------------------
plot(X(Y < 0, 2), Y(Y<0,1), 'rx', 'linewidth', 2);
plot(X(Y > 0, 2), Y(Y>0,1),  'go', 'linewidth', 2);
x1 = min(X(:,2)):.01:max(X(:,2));
%x1 = -theta(1)/theta(2);
%y = -2:.001:2;
%disp(y);
x2 = theta(1)  +theta(2) * x1;
y = 2*(1./ (1 + exp(-x2)))-1;

plot(x1,y, 'linewidth', 2);
xlabel('x1');
ylabel('Y');
%
predict=X * theta;
acc=sum(((predict>0)*2-1)~=Y)/m;
disp(acc);
end

function [theta,ll] = log_regression(X,Y)
max_iters=40;
% rows of X are training samples
% rows of Y are corresponding -1/1 values
% newton raphson: theta = theta - inv(H)* grad;
% with H = hessian, grad = gradient
%Y = Y-1.5;

mm = size(X,1);
nn = size(X,2);
theta = zeros(nn,1);
ll = zeros(max_iters, 1);
for ii = 1:max_iters
    margins = Y .* (X * theta);
    ll(ii) = (1/mm) * sum(log(1 + exp(-margins)));
    probs = 1 ./ (1 + exp(margins));
    grad = -(1/mm) * (X' * (probs .* Y));
    H = (1/mm) * (X' * diag(probs .* (1 - probs)) * X);
    theta = theta - H \ grad;


    %%%%%%%%%%%%%%
end
a=X * theta;
predict = 1 ./ (1 + exp(-a));
acc=sum(((predict>1.5)*2-1)==Y)/mm;
disp(theta);
end
