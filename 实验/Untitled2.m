X1=load('ex3blue.dat');
X2=load('ex3green.dat');
X3=load('ex3red.dat');
hold on
plot(X1(:,1),X1(:,2),'b*','markerfacecolor', [ 1, 0, 0 ]);
plot(X2(:,1),X2(:,2),'g*','markerfacecolor', [ 0, 0, 1 ]);
plot(X3(:,1),X3(:,2),'r*','markerfacecolor', [ 0, 1, 0 ]);
grid on
M1 = mean(X1);
M2 = mean(X2);
M3 = mean(X3);
M = mean([X1;X2;X3]);
%第二步：求类内散度矩阵
p = size(X1,1);
q = size(X2,1);
r = size(X3,1);
a=repmat(M1,14,1);
S1=(X1-a)'*(X1-a);
b=repmat(M2,14,1);
S2=(X2-b)'*(X2-b);
c=repmat(M3,14,1);
S3=(X3-c)'*(X3-c);
Sw=(p*S1+q*S2+r*S3)/(p+q+r);
%第三步：求类间散度矩阵
sb1=(M1-M)'*(M1-M);
sb2=(M2-M)'*(M2-M);
sb3=(M3-M)'*(M3-M);
Sb=(p*sb1+q*sb2+r*sb3)/(p+q+r);
bb=det(Sw);
%第四步：求最大特征值和特征向量
[V,L]=eig(inv(Sw)*Sb);
[a,b]=max(max(L));
W = V(:,b);%最大特征值所对应的特征向量
%第五步：画出投影线
k=W(2)/W(1);
b=0;
x=1:9;
yy=k*x+b;
plot(x,yy);%画出投影线
%计算第一类样本在直线上的投影点
xi=[];
for i=1:p    
    y0=X1(i,2);    
    x0=X1(i,1);    
    x1=(k*(y0-b)+x0)/(k^2+1);    
    xi=[xi;x1];
end
yi=k*xi+b;
XX1=[xi yi];
%计算第二类样本在直线上的投影点
xj=[];
for i=1:q    
    y0=X2(i,2);    
    x0=X2(i,1);    
    x1=(k*(y0-b)+x0)/(k^2+1);    
    xj=[xj;x1];
end
yj=k*xj+b;
XX2=[xj yj];
%计算第三类样本在直线上的投影点
xk=[];
for i=1:q    
    y0=X3(i,2);    
    x0=X3(i,1);    
    x1=(k*(y0-b)+x0)/(k^2+1);    
    xk=[xk;x1];
end
yk=k*xk+b;
XX3=[xk yk];
% y=W'*[X1;X2]';
plot(XX1(:,1),XX1(:,2),'b+','markerfacecolor', [ 1, 0, 0 ]);
plot(XX2(:,1),XX2(:,2),'g+','markerfacecolor', [ 0, 0, 1 ]);
plot(XX3(:,1),XX3(:,2),'r+','markerfacecolor', [ 0, 1, 0 ]);

