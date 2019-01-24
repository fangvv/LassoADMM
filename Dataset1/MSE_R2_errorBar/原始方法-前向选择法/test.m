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
for Block = [90]
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
    his.wResult = zeros(Block, features);
    his.lossResult = zeros(Block, 1);
%     myIter = 0;
%     MSE = 0;
%     R2 = 0;
%     R2Adjusted = 0;
%     testMSE = 0;
%     testR2 = 0;
%     testR2Adjusted = 0;
    myIter = zeros(Block);
    MSE = zeros(Block);
    R2 = zeros(Block);
    R2Adjusted = zeros(Block);
    testMSE= zeros(Block);
    testR2 = zeros(Block);
    testR2Adjusted = zeros(Block);
    index0 = 1;
    index1 = 1;
    R2index0 = 1;
    R2index1 = 1;
    R2Adjustedindex0 = 1;
    R2Adjustedindex1 = 1;
    for index = 1:Block
        xTrain = x((index-1)*oneBlock + 1 : index*oneBlock, :);
        yTrain = y((index-1)*oneBlock + 1 : index*oneBlock,:);
        [wResult1,lossResult1,history] = stageWise(xTrain, yTrain, eps, runtime, testExamples);
        his.wResult(index,:) = wResult1(runtime,:);
        his.lossResult(index,:) = lossResult1(runtime,:);
        myIter(index) = history.myIter;
        MSE(index) = history.MSE;
%         mse = MSE
        R2(index) = history.R2;
        R2Adjusted(index) = history.R2Adjusted;
        testMSE(index) = history.testMSE;
        testR2(index) = history.testR2;
        testR2Adjusted(index) = history.testR2Adjusted;
        %%MSE在测试机上最小的点，最大的点
        if history.testMSE < testMSE(index0)
            index0 = index;
        end
        if history.testMSE > testMSE(index1)
            index1 = index;
        end
        
        %%R2在测试机上最小的点,最大的点
        if history.R2 < testR2(R2index0)
            R2index0 = index;
        end
        if history.R2 > testR2(R2index1)
            R2index1 = index;
        end
        
        %%R2Adjusted在测试机上最小的点,最大的点
        if history.R2Adjusted < testR2Adjusted(R2Adjustedindex0)
            R2Adjustedindex0 = index;
        end
        if history.R2Adjusted > testR2Adjusted(R2Adjustedindex1)
            R2Adjustedindex1 = index;
        end
        
%         testmse = testMSE
        
    end
    wResult = his.wResult(index0,:);
    lossResult = his.lossResult(index0,:);
    
    myIter_now = myIter(index0);
    MSE_low = MSE(index0);
    R2_low = R2(index0);
    R2Adjusted_low = R2Adjusted(index0);
    testMSE_low = testMSE(index0);
    testMSE_high = testMSE(index1);
    testR2_low = testR2(index0);
    testR2_high = testR2(index1);
    testR2Adjusted_low = testR2Adjusted(index0);
    testR2Adjusted_high = testR2Adjusted(index1);%%根据MSE的最大最小决定R2和R2Adjusted大小
    
    my_testR2_low = testR2(R2index0);
    my_testR2_high = testR2(R2index1);
    my_testR2Adjusted_low = testR2Adjusted(R2Adjustedindex0);
    my_testR2Adjusted_high = testR2Adjusted(R2Adjustedindex1);%%根据MSE的最大最小决定R2和R2Adjusted大小
    
    
    %% 找到当前路径
    p = mfilename('fullpath');
    i = findstr(p,'\');
    saveFile = p(1:i(end));

    %% 迭代次数写文件
    iterFileName = [saveFile, 'iter.txt'];              %目标函数文件
    fiter = fopen(iterFileName,'a');                % 迭代次数文件
    fprintf(fiter,'%-5d %-5d\r\n',Block, myIter_now);
    fclose(fiter);
    %% 误差写入文件
    evaluateFile = [saveFile,'MSE.txt'];       %记录MSE R2 R2_Adjusted
    fevaluate1 = fopen(evaluateFile,'a');          % 均方误差等错误率文件
    fprintf(fevaluate1,'%-5d %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f %-5f\r\n',Block, MSE_low, R2_low, R2Adjusted_low, testMSE_low ,testMSE_high,testR2_low,testR2_high,testR2Adjusted_low,testR2Adjusted_high,my_testR2_low,my_testR2_high,my_testR2Adjusted_low,my_testR2Adjusted_high ); %错误率文件：写入 MSE + R2 + R2_Adjusted
    fclose(fevaluate1);%%从左到右依次为在MSE最大最小时训练集上的MSE，R2，R2Adjusted;测试集上MSE，R2，R2Adjusted最大最小值;不依赖MSE时的R2，R2Adjusted值

    %% 特征向量值
    paramFile = [saveFile,'featureVector.txt'];
    fVector = fopen(paramFile,'a');                % 将数据保存到文件中
    fprintf(fVector,'%-5d ',Block);       %特征向量文件：写入特征向量
    fprintf(fVector,'%-5f ',his.wResult(index0,:));       %特征向量文件：写入特征向量
    fprintf(fVector,'\r\n');
    fclose(fVector);

    %% 根据wResult画出收敛曲线
    hold on 
    xAxis = 1:runtime;
    for i = 1:n
        plot(xAxis, wResult1(:,i));
    end
    %% 保存图像文件
%     saveObjImg = [saveFile,'\coefficient.png'];
%     saveas(gcf,saveObjImg);

    %%目标函数图
    h = figure;
    plot(xAxis, lossResult1);
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