function [w,v,history] = lassoConjGradTest(rho, lambda, yalmipFile,patientNo,dataName,dirName)


t_start = tic;%设置时间戳

dataFile = [yalmipFile,'\',dataName];
dataAll = load(dataFile);  %从文件读数据

% dataAll = dataAll(1:400,:);  % 根据病人数量动态调整数据数目
% dataAll(401:800,:) = dataAll(1:400,:);
% dataAll(801:1600,:) = dataAll(1:800,:);

[w,v,W_i, V_i, history] = lassoConjGrad(dataAll, lambda, rho, patientNo);

K = length(history.primObjective);
paramFile = [yalmipFile,'\',dataName,'_featureVector.txt'];
evaluateFile1 = [yalmipFile,'\',dataName,'_MSE_R2.txt'];       %记录MSE R2 R2_Adjusted

%创建目标函数文件夹
objectPath = [yalmipFile,'\目标函数文件'];            %% 创建目标函数文件夹
if ~exist(objectPath)
    mkdir(objectPath)
end;    
strpatientNo = num2str(patientNo,'%3d');                        %UE个数转换为字符串
objectFileName = [objectPath,'\',strpatientNo,'.txt'];              %目标函数文件

%创建迭代次数文件夹
iterFile = [yalmipFile,'\迭代次数文件'];            %% 创建目标函数文件夹
if ~exist(iterFile)
    mkdir(iterFile)
end;    

iterFileName = [iterFile,'\','iter.txt'];              %迭代次数文件

fVector = fopen(paramFile,'a');                % 将数据保存到文件中
fevaluate1 = fopen(evaluateFile1,'a');          % 均方误差等错误率文件
fobject = fopen(objectFileName,'a');            % 目标函数文件
fiter = fopen(iterFileName,'a');                % 迭代次数文件

fprintf(fVector,'\r\n %-5d: ',patientNo);    %写入 UE 个数值
fprintf(fevaluate1,'%-5d ',patientNo);

%迭代次数文件：写入 UE + lambda + rho + iter
fprintf(fiter,'%-5d %-5d %-5d %-5d\r\n',patientNo, lambda, rho, history.OriginalResidualsIter);

for i = 1:K                                   %目标函数文件：写入目标函数值
    fprintf(fobject,'%-5d ',i);
    fprintf(fobject,'%-5d ',history.beforeADMMObjective(i));
    fprintf(fobject,'%-5d ',history.primObjective(i));
    fprintf(fobject,'%-5d\r\n',history.dualObjective(i));
end;

fprintf(fVector,' %-5f ',w);       %特征向量文件：写入特征向量 + 截距
fprintf(fVector,' %-5f\r\n',v);

fprintf(fevaluate1,'%-5f %-5f %-5f %-5f %-5f %-5f\r\n',history.MSE(K), history.R2(K), history.R2_adjusted(K),history.testMSE, history.testR2, history.testR2_adjusted ); %错误率文件：写入 MSE + R2 + R2_Adjusted

fclose(fVector);   %关闭文件
fclose(fevaluate1);
fclose(fobject);
fclose(fiter)

strlambda = num2str(lambda,'%3f');
strrho = num2str(rho,'%3f');
strpatientNo = num2str(patientNo,'%3d');                        %UE个数转换为字符串
saveFile = [yalmipFile,dirName,strpatientNo,'λ',strlambda,'ρ',strrho];

if ~exist(saveFile)
    mkdir(saveFile)
end;

%绘制目标函数值的图像
K = length(history.primObjective);
h = figure;
plot(1:K, history.beforeADMMObjective, 'k-', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
% t1 = [1, K];
optiobjvalArray = zeros(1,K) + history.optiobjval;
% t2 = [history.optiobjval, history.optiobjval];
plot(1:K, optiobjvalArray, 'r--', 'MarkerSize', 10, 'LineWidth', 2);
% set(gca,'FontSize',16);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
legend('ADMM','Centralized');
ylabel('Objective Function Value'); xlabel('Iteration');
set(gca,'FontSize',16);
saveObjImg = [saveFile,'\Objective.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\Objective.eps'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\Objective.png'];
saveas(gcf,saveObjImg);

%绘制lasso回归的系数图像：当特征很多的时候能够观察到哪个特征决定性作用比较大
h1 = figure;
plot(w,'k-','MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(history.optW,'r--','MarkerSize', 10, 'LineWidth', 2);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
legend('ADMM','Centralized');
ylabel('Coefficient'); xlabel('Feature');
set(gca,'FontSize',16);
saveObjImg = [saveFile,'\Coefficient.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\Coefficient.eps'];
saveas(gcf,saveObjImg);
%绘制R方值、R方校正值
h2 = figure;
plot(1:K, history.R2,'k-','MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(1:K, history.R2_adjusted,'r--','MarkerSize', 10, 'LineWidth', 2);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
legend('R^2','R^2Adjusted');
xlabel('Iteration');
set(gca,'FontSize',16);
ylabel('R^2 Score');
saveObjImg = [saveFile,'\R2.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\R2.eps'];
saveas(gcf,saveObjImg);
%绘制训练集误差值
h3 = figure;
plot(1:K, history.MSE,'r-','MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(1:K, history.centralizeMSE,'k--','MarkerSize', 10, 'LineWidth', 2);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
legend('ADMM','Centralized');
xlabel('Iteration');
set(gca,'FontSize',16);
ylabel('Mean Squared Error');
saveObjImg = [saveFile,'\MSE.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\MSE.eps'];
saveas(gcf,saveObjImg);
%绘制原始残差、对偶残差的图像
g = figure;
subplot(2,1,1);
semilogy(1:K, max(1e-8, history.r_norm), 'k-', ...
    1:K, history.eps_pri, 'r--',  'LineWidth', 2);
% set(gcf,'Units','centimeters','Position',[6 6 14.12 12]);
% set(gca,'Position',[.07 .07 .8 .3]);
% set(get(gca,'XLabel'),'FontSize',16);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
subplot(gca,'Position',[.07 .07 .8 .3]);
set(get(gca,'XLabel'),'FontSize',16);
xlabel('Iteration');
% legend('{\it{$ \left\|r\right\|_2 $}}','stop-condition');
legendL=legend('$ \left\|r\right\|_2  $','$ \epsilon^{pri}  $','Position',[50 60 500 470]); %latex分式
set(legendL,'Interpreter','latex') %设置legend为latex解释器显示分式
ylabel('Value');
set(gca,'FontSize',16);

subplot(2,1,2);
semilogy(1:K, max(1e-8, history.s_norm), 'k-', ...
    1:K, history.eps_dual, 'r--', 'LineWidth', 2);
% set(gcf,'Units','centimeters','Position',[6 6 14.12 12]);
% set(gca,'Position',[.15 .15 .8 .3]);
% set(get(gca,'XLabel'),'FontSize',16);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
subplot(gca,'Position',[.15 .15 .8 .3]);
set(get(gca,'XLabel'),'FontSize',16);
% legend('$ \left\|s\right\|_2 $','stop-condition');
legendL=legend('$ \left\|s\right\|_2 $','$ \epsilon^{dual}  $'); %latex分式
set(legendL,'Interpreter','latex') %设置legend为latex解释器显示分式
ylabel('Value'); xlabel('Iteration');
set(gca,'FontSize',16);

saveResidualImg = [saveFile,'\Residual.pdf'];
saveas(gcf,saveResidualImg);
saveResidualImg = [saveFile,'\Residual.eps'];
saveas(gcf,saveResidualImg);
saveResidualImg = [saveFile,'\Residual.png'];
saveas(gcf,saveResidualImg);
% system('shutdown -s');
