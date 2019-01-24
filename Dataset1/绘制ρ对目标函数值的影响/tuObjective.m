% arrayResult = dlmread('hztxtResult.txt',',');

%绘制目标函数图像
h2 = figure;
dirName = '目标函数文件';
arrayResult = tu(dirName, '0.100000.txt');
[iter, col] = size(arrayResult);
Markersize = 10;
lineWidth = 1;
xAris = 1:5:200;
plot(xAris, arrayResult(xAris,2),'s--','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '0.500000.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'x--','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '1.000000.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'>:','LineWidth',1.5);
hold on;
arrayResult = tu(dirName, '2.000000.txt');
[iter, col] = size(arrayResult);
plot(xAris, arrayResult(xAris,2),'o--','LineWidth',1.5);

set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);
xlabel('Iteration');
ylabel('Objective Function Value');
legend( '{\it{ρ = 0.1}}','{\it{ρ = 0.5}}', '{\it{ρ = 1.0}}','{\it{ρ = 2.0}}');
grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
set(gca,'FontSize',16);
%%找到当前路径
p = mfilename('fullpath');
i = findstr(p,'\');
saveFile = p(1:i(end));

%%保存图像文件
saveObjImg = [saveFile,'\ρObjective.eps'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\ρObjective.pdf'];
saveas(gcf,saveObjImg);
saveObjImg = [saveFile,'\ρObjective.png'];
saveas(gcf,saveObjImg);