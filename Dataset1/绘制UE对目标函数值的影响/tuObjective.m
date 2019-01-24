% arrayResult = dlmread('hztxtResult.txt',',');

%绘制目标函数图像
h2 = figure;
dirName = '目标函数文件';
arrayResult = tu(dirName, '10.txt');
[iter, col] = size(arrayResult);
Markersize = 10;
lineWidth = 1;
xAris = 1:5:200;
plot(xAris, arrayResult(xAris,2),'s--','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '20.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'x-','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '30.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'o--','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '40.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'>:','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '50.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'+:','LineWidth',1.5);
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
xlabel('Iteration');
ylabel('Objective Function Value');
legend( '{\it{N = 10}}','{\it{N = 20}}', '{\it{N = 30}}','{\it{N = 40}}','{\it{N = 50}}');
grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
set(gca,'FontSize',16);
%%找到当前路径
p = mfilename('fullpath');
i = findstr(p,'\');
saveFile = p(1:i(end));

%%保存图像文件
saveObjImg = [saveFile,'\UEObjective.eps'];
saveas(gcf,saveObjImg);

saveObjImg = [saveFile,'\UEObjective.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\UEObjective.png'];
saveas(gcf,saveObjImg);
