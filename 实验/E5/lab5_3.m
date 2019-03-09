clear;clc;
matr1=load('d:\MATLAB\matlab\bin\LAB5\data5\data5\training_3.txt');
x1=matr1(:,1:2);y1=matr1(:,3);
%惩罚力度越大对错误容忍度越低,预测越准确
%gamma越小，高斯分布越宽，gamma相当于调整模型的复杂度，gamma值越小模型复杂度越低，gamma值越高，模型复杂度越大
%σ称为径向基函数的扩展常数，它反应了函数图像的宽度，σ越小，宽度越窄，函数越具有选择性。
%参数gamma过大，支持向量的影响半径将小到只能影响到它自己，这时再怎么调整参数C也不能避免过拟合
%***************************************
figure;
C=1;
sigma = 0.5;
svmStr = svmtrain(x1,y1,'kernel_function','rbf','rbf_sigma',sigma,'boxconstraint',C,'showplot',true);
title(sprintf('SVM Linear Classifier with C = %g,sigma = %g', C,sigma), 'FontSize', 14)
%******************************************
figure;
C=1;
sigma = 0.2;
svmStr = svmtrain(x1,y1,'kernel_function','rbf','rbf_sigma',sigma,'boxconstraint',C,'showplot',true);
title(sprintf('SVM Linear Classifier with C = %g,sigma = %g', C,sigma), 'FontSize', 14)
%***********************************************
figure;
C=1;
sigma = 0.1;
svmStr = svmtrain(x1,y1,'kernel_function','rbf','rbf_sigma',sigma,'boxconstraint',C,'showplot',true);
title(sprintf('SVM Linear Classifier with C = %g,sigma = %g', C,sigma), 'FontSize', 14)