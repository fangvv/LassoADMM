clear;clc;

%% 找到当前路径
p = mfilename('fullpath');
i = findstr(p,'\');
yalmipFile = p(1:(i(end)-1));
    
% yalmipFile = 'D:\GitHub\ADMM\王雪毕设材料\使用共轭梯度法';
dataName = 'sto.tab.v2.txt';
dirName = '\sto.tab.v2_patientNo';

rho = 1.0;        % 参数值
lambda = 1.0;
patientNo=5;
while(patientNo<=50)
    [w,v,history] = lassoConjGradTest(rho, lambda, yalmipFile,patientNo,dataName,dirName);    
    patientNo= patientNo + 5;
end;

% system('shutdown -s');

%  50   :  5.913099  0.763334  -0.754497  39.684914  0.065733  -228.887446
%  1    :  5.888013  0.830030  -0.737326  42.140901  0.210671  -259.392100
