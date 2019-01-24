%% rssError函数主要是利用均方误差
function [ error ] = rssError( y, yTest )
    yDis = y-yTest;%误差
    [m,n] = size(yDis);
    %求平方
    for i = 1:m
        yDis(i) = yDis(i)^2;
    end
    error = sum(yDis);%求列和
end