clear all;
clc;
%% 导入数据
data = load('sto.tab.v2.txt');
x = data(:,1:10);
y = data(:,11);

%% 处理数据
yMean = mean(y);
yDeal = y-yMean;
xMean = mean(x);
xVar = var(x,1);
[m,n] = size(x);
xDeal = zeros(m,n);
for i = 1:m
    for j = 1:n
        xDeal(i,j) = (x(i,j)-xMean(j))/xVar(j);
    end
end
 
%% 训练
runtime  = 40000;%迭代的步数
eps = 0.001;%调整步长
for Block = [50]
    %% 划分数据集
    
    [examples,Col] = size(data);
    %% 为模型加上截距
    dataTmp = zeros(examples,Col+1);
    dataTmp(:,1) = ones(examples,1);  %设置第一列为1，为截距做拟合用
    dataTmp(:,2:Col+1) = data(:,:);
    data = dataTmp;

    trainingNum = floor(examples*0.7);
    testExamples = data(trainingNum+1:examples,:);
    data = data(1:trainingNum,:);

    x = data(:, 1:Col);
    y = data(:, Col+1);
    features = Col;
    oneBlock = floor(trainingNum/Block);% 每个块提供样本数
    %% 多次训练求平均
    his.wResult = zeros(runtime, features);
    his.lossResult = zeros(runtime, 1);
    myIter = 0;
    MSE = 0;
    R2 = 0;
    R2Adjusted = 0;
    testMSE = 0;
    testR2 = 0;
    testR2Adjusted = 0;
    for index = 1:Block
        xTrain = x((index-1)*oneBlock + 1 : index*oneBlock, :);
        yTrain = y((index-1)*oneBlock + 1 : index*oneBlock,:);
        [wResult1,lossResult,history] = stageWise(xTrain, yTrain, eps, runtime, testExamples);
        his.wResult = his.wResult + wResult1;
        his.lossResult = his.lossResult + lossResult;
        myIter = myIter + history.myIter;
        MSE = MSE + history.MSE;
        mse = MSE
        R2 = R2 + history.R2;
        R2Adjusted = R2Adjusted + history.R2Adjusted;
        testMSE = testMSE + history.testMSE;
        testmse = testMSE
        testR2 = testR2 + history.testR2;
        testR2Adjusted = testR2Adjusted + history.testR2Adjusted;
    end
    wResult = his.wResult/Block;
    lossResult = his.lossResult/Block;
    
    myIter = floor(myIter/Block);
    MSE = MSE/Block;
    R2 = R2/Block;
    R2Adjusted = R2Adjusted/Block;
    testMSE = testMSE/Block;
    testR2 = testR2/Block;
    testR2Adjusted = testR2Adjusted/Block;
    
    %% 找到当前路径
    p = mfilename('fullpath');
    i = findstr(p,'\');
    saveFile = p(1:i(end));

    %% 迭代次数写文件
    iterFileName = [saveFile, 'iter.txt'];              %目标函数文件
    fiter = fopen(iterFileName,'a');                % 迭代次数文件
    fprintf(fiter,'%-5d %-5d\r\n',Block, myIter);
    fclose(fiter);
    %% 误差写入文件
    evaluateFile = [saveFile,'MSE_R2.txt'];       %记录MSE R2 R2_Adjusted
    fevaluate1 = fopen(evaluateFile,'a');          % 均方误差等错误率文件
    fprintf(fevaluate1,'%-5d %-5f %-5f %-5f %-5f %-5f %-5f\r\n',Block, MSE, R2, R2Adjusted, testMSE ,testR2,testR2Adjusted ); %错误率文件：写入 MSE + R2 + R2_Adjusted
    fclose(fevaluate1);

    %% 特征向量值
    paramFile = [saveFile,'featureVector.txt'];
    fVector = fopen(paramFile,'a');                % 将数据保存到文件中
    fprintf(fVector,'%-5d ',Block);       %特征向量文件：写入特征向量
    fprintf(fVector,'%-5f ',his.wResult(runtime,:)/Block);       %特征向量文件：写入特征向量
    fprintf(fVector,'\r\n');
    fclose(fVector);

    %% 根据wResult画出收敛曲线
    hold on 
    xAxis = 1:runtime;
    for i = 1:n
        plot(xAxis, wResult(:,i));
    end
    %% 保存图像文件
%     saveObjImg = [saveFile,'\coefficient.png'];
%     saveas(gcf,saveObjImg);

    %%目标函数图
    h = figure;
    plot(xAxis, lossResult);
    %% 保存图像文件
    saveObjImg = [saveFile,'\Objective.png'];
    saveas(gcf,saveObjImg);
    
    %%MSE 图
    h = figure;
    plot(xAxis, history.MSEN);
    %% 保存图像文件
%     saveObjImg = [saveFile,'\MSE.png'];
%     saveas(gcf,saveObjImg);
end