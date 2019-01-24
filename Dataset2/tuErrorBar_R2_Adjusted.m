p1 = mfilename('fullpath');
i = findstr(p1,'\');
pPath = p1(1:i(end));

ADMMFile = 'scaledSKlearnData.tab.txt_MSE_R2.txt';
cd(pPath);
dataADMM = load(ADMMFile);
xAxis = dataADMM(:,1);

testMSE = dataADMM(:,5);
testR2 = dataADMM(:,6);
testR2Adjusted = dataADMM(:,7);

CentralizedFile = 'MSE.txt';
dataCentralized = load(CentralizedFile);
CentralizedtestMSE = dataCentralized(:,5);
CentralizedtestMSE_high = dataCentralized(:,6);
CentralizedtestR2 = dataCentralized(:,7);
CentralizedtestR2_high = dataCentralized(:,8);
CentralizedtestR2Adjusted = dataCentralized(:,9);
CentralizedtestR2Adjusted_high = dataCentralized(:,10);

CentralizedtestR21 = dataCentralized(:,11);
CentralizedtestR21_high = dataCentralized(:,12);
CentralizedtestR2Adjusted1 = dataCentralized(:,13);
CentralizedtestR2Adjusted1_high = dataCentralized(:,14);

%% 找到当前路径
saveFile = p1(1:i(end));
%% R^2  Adjusted 图：选择的最大最小值与MSE下标同步
CentralizedtestR2Adjusted_mid = (CentralizedtestR2Adjusted + CentralizedtestR2Adjusted_high)/2;
volumeR2Adjusted_std = (CentralizedtestR2Adjusted_high - CentralizedtestR2Adjusted)/2;
H1 = figure;
%% 设置图的位置及大小
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);

%% 分布式图例
plot(xAxis,testR2Adjusted,'s--','linewidth',1.5);
set(gca,'XTickMode','manual','XTick',[1 10 20 30 40 50]); 
set(gca,'FontSize',16);
xlabel('{\it{N}}');
ylabel('Adjusted R^2 Value');
grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
axis([-3, 55,-2,1.5]);
hold on;
errorbar(xAxis,CentralizedtestR2Adjusted_mid,volumeR2Adjusted_std,'>:','linewidth',1.5);
legend('ADMM','Independent','location','northeast');
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);

% %% 箭头
% annotation('textarrow',[.5,.5],[.8,.7],'linewidth',1.5);
% %% 生成子图
% axes('Position',[0.25,0.35,0.55,0.33]);   
% %% 子数据集
% xa = 1:4;
% testR2Adjusted0 = testR2Adjusted(xa,:);
% CentralizedtestR2Adjusted_mid0 = CentralizedtestR2Adjusted_mid(xa,:);
% volume_std0 = volumeR2Adjusted_std(xa,:);
% xAxis0 = [1 15 30 45];
% 
% plot(xAxis0,testR2Adjusted0,'s--','linewidth',1.5);
% set(gca,'XTickMode','manual','XTick',[1 15 30 45],'YTick',[0.983 0.989 0.995 1.001 1.007 1.013]); 
% set(gca,'FontSize',12);
% grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
% axis([-5, 55,0.983,1.013]);
% hold on;
% errorbar(xAxis0,CentralizedtestR2Adjusted_mid0,volume_std0,'>:','linewidth',1.5);
%% 保存图像
% saveObjImg = [saveFile,'\R2Adjusted.png'];
% saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\R2Adjusted.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\R2Adjusted.png'];
saveas(gcf,saveObjImg);
