clear;clc;
%12665
temp=50;
grid=zeros(temp,5000);
y=zeros(temp,1);
[grid,y]=strimage(temp,grid,y);
% Train the model and get the primal variables w, b from the model
% Libsvm options
% -s 0 : classification
% -t 0 : linear kernel
% -c somenumber : set the cost
% Set the cost
C = 100000;
model = svmtrain(y,grid, sprintf('-s 0 -t 0 -c %g', C));
w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)
    w = -w; b = -b;
end
[num,rate]=testdata(w,b);

fprintf('*******正确个数：%d*********准确率：%d******************\n',num,rate);
