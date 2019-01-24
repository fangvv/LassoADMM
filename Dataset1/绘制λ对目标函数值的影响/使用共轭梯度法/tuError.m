p1 = mfilename('fullpath');
i = findstr(p1,'\');
pPath = p1(1:i(end));

ADMMFile = 'sto.tab.v2.txt_MSE_R2.txt';
cd(pPath);
dataADMM = load(ADMMFile);
xAxis = dataADMM(:,1);
MSE = dataADMM(:,2);
R2 = dataADMM(:,3);
R2Adjusted = dataADMM(:,4);
testMSE = dataADMM(:,5);
testR2 = dataADMM(:,6);
testR2Adjusted = dataADMM(:,7);

CentralizedFile = 'MSE_R2.txt';
cd(pPath);
dataCentralized = load(CentralizedFile);
xAxis = dataCentralized(:,1);
CentralizedMSE = dataCentralized(:,2);
CentralizedR2 = dataCentralized(:,3);
CentralizedR2Adjusted = dataCentralized(:,4);
CentralizedtestMSE = dataCentralized(:,5);
CentralizedtestR2 = dataCentralized(:,6);
CentralizedtestR2Adjusted = dataCentralized(:,7);

%% MSE 图
h2 = figure;
% Markersize = 10;
% lineWidth = 2;
% plot(xAxis, MSE,'s--');
hold on;
plot(xAxis, testMSE,'x-');
% plot(xAxis, CentralizedMSE,'o--');
plot(xAxis, CentralizedtestMSE,'>:');

set(gca,'FontSize',16);
xlabel('Num of UE');
ylabel('MSE Value');
legend( 'ADMM-trainMSE','ADMM-testMSE','Centralized-trainMSE','Centralized-testMSE');
grid on;

%% 找到当前路径
p = mfilename('fullpath');
i = findstr(p,'\');
saveFile = p(1:i(end));

%% 保存图像文件
saveObjImg = [saveFile,'\Error.png'];
saveas(gcf,saveObjImg);