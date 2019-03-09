function test_linear_regression()
% 读入数据
X = load('ex1x.dat'); Y = load('ex1y.dat');
X = [ones(size(X, 1), 1) X];
% 计算 theta
%%%%%课堂完成内容，用梯度下降方法替换theta的计算
%theta = pinv(X)*Y; % theta = inv(X'*X)*X'*Y;
arfa= 0.00015;
[a,b] = size(X);
theta = ones(1,b);
tmp1 = loss_function(theta,X,Y);
while 1
    theta = descent(theta,X,Y,arfa);
    tmp2 = loss_function(theta,X,Y); 
    disp(tmp1-tmp2);
    if(abs(tmp1 -tmp2) <= 1.0e-6)
        break;
    end
    tmp1 = tmp2;
   % disp(theta);
end 
disp(theta);
h = theta*X(1,:)';
disp(abs(h-Y(1,:))/Y(1,:));
h = theta*X(221,:)';
disp(abs(h-Y(221,:))/Y(221,:));
h = theta*X(331,:)';
disp(abs(h-Y(331,:))/Y(331,:));
%disp(tmp1);
%绘制图像%
figure; hold on;
plot(X(Y <= 1, 2), X(Y <= 1, 3), 'rx', 'linewidth', 2);
plot(X(Y > 1, 2), X(Y > 1, 3), 'go', 'linewidth', 2);
x1 = min(X(:,2)):.1:max(X(:,2));

x2 = -(theta(1) / theta(3)) - (theta(2) / theta(3)) * x1+1/theta(3)*1.5;
plot(x1,x2, 'linewidth', 2);
xlabel('x1');   ylabel('x2');
end

function [sum] = loss_function(theta,X,Y)
    sum =0;
    [a,b] = size(X);
    for i = 1:a
        h = theta*X(i,:)';
        sum = sum + (h-Y(i,1))*(h-Y(i,1));
    end
    sum = sum/(2*a);
end