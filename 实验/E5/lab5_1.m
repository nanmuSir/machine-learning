clc;clear;
matr1=load('email_train-50.txt');
matr2=load('email_test.txt');
x1=matr1(:,1:2);y1=matr1(:,3);figure;
x2=matr2(:,1:2);y2=matr2(:,3);
pos=find(matr1(:,3)==1);neg=find(matr1(:,3)==-1);
plot(matr1(pos,1),matr1(pos,2),'+') 
hold on
plot(matr1(neg,1),matr1(neg,2),'o')

% Train the model and get the primal variables w, b from the model
% Libsvm options
% -s 0 : classification
% -t 0 : linear kernel
% -c somenumber : set the cost
% Set the cost
C = 1;%惩罚力度越大对错误容忍度越低
model = svmtrain(y1, x1, sprintf('-s 0 -t 0 -c %g', C));
%测试分类
[predict_label, accuracy, dec_values]=libsvmpredict(y2,x2,model);

w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)
    w = -w; b = -b;
end

% 画出决策边界

title(sprintf('SVM Linear Classifier with C = %g', C), 'FontSize', 14)
plot_x = linspace(min(x1(:,1)), max(x1(:,1)), 30);
plot_y = (-1/w(2))*(w(1)*plot_x + b);
plot(plot_x, plot_y, 'k-', 'LineWidth', 1)
plot_y1 = (-1/w(2))*(w(1)*plot_x + b+1);
plot(plot_x, plot_y1, 'k-', 'LineWidth', 1)
plot_y2 = (-1/w(2))*(w(1)*plot_x + b-1);
plot(plot_x, plot_y2, 'k-', 'LineWidth', 1)

%测试数据
figure
x2=matr2(:,1:2);y2=matr2(:,3);
pos=find(matr2(:,3)==1);neg=find(matr2(:,3)==-1);
plot(matr2(pos,1),matr2(pos,2),'+') 
hold on
plot(matr2(neg,1),matr2(neg,2),'o')
plot_x = linspace(min(x1(:,1)), max(x1(:,1)), 30);
plot_y = (-1/w(2))*(w(1)*plot_x + b);
plot(plot_x, plot_y, 'k-', 'LineWidth', 1)
plot_y1 = (-1/w(2))*(w(1)*plot_x + b+1);
plot(plot_x, plot_y1, 'k-', 'LineWidth', 1)
plot_y2 = (-1/w(2))*(w(1)*plot_x + b-1);
plot(plot_x, plot_y2, 'k-', 'LineWidth', 1)
num=0;
for i=1:1:length(matr2)
    temp=y2(i,:)*(x2(i,:)*w+b)
    x2(i,:)
    if(temp>0)
        num=num+1;
    end
end
num
rate=num/length(matr2);
fprintf('数据准确率为:%d',rate);

% 
