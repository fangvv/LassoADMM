clear;clc;
data = load('iter.txt');
iter1 = data(:,4);
disp(iter1);
h = figure;
h1 = cdfplot(iter1);
h1.Marker = 'o';
h1.Color = [0.2 0.2 1 ];
set(h1,'color',h1.Color,'Linewidth',1.5)
hold on;
%% centralized CDF
data2 = load('Centralizediter.txt');
iter2 = data2(:,2);
h2 = cdfplot(iter2);
h2.Marker = '*';
h2.Color = [0.9 0.5 0.5 ];
set(gca,'FontSize',16);
set(h2,'color',h2.Color,'Linewidth',1.5)
set(gcf,'Units','centimeters','Position',[6 6 14.5 12]);
set(gca,'Position',[.15 .15 .8 .75]);
set(get(gca,'XLabel'),'FontSize',16);

xlabel('Iteration');
ylabel('CDF');
legend('ADMM','Centralized','Position',[5 60 400 450]);
grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
title('');

%%找到当前路径
p = mfilename('fullpath');
i = findstr(p,'\');
saveFile = p(1:i(end));

%%保存图像文件
saveObjImg = [saveFile,'\CDF.pdf'];
saveas(gcf,saveObjImg);

saveObjImg = [saveFile,'\CDF.eps'];
saveas(gcf,saveObjImg);

saveObjImg = [saveFile,'\CDF.png'];
saveas(gcf,saveObjImg);