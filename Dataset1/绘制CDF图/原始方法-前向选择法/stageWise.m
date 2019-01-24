function [ wResult, lossResult, history ] = stageWise( x, y, eps, runtime, testExamples)
%     t_start = tic;%设置时间戳
    [m,n] = size(x);%数据集的大小
    wResult = zeros(runtime, n);%最终的结果
    lossResult = zeros(runtime, 1);%损失函数
    lossResultOld = 10000000;
    w = zeros(n,1);
    yTest = x*w;
    wMax = zeros(n,1);
    eps = 1e-2;
    flag = 0;
    for i = 1:runtime
        ws = w'%输出每一次计算出来的权重
        wold = w;
        
        lowestError = inf;%定义最小值
        for j = 1:n
            for sign = -1:2:1
                wTest = w;%初始化
                wTest(j) = wTest(j)+eps*sign;%只改变一维变量
                yTest = x*wTest;
                %求误差
                rssE = rssError(y, yTest);
                if rssE < lowestError%如果好，就替换
                    lowestError = rssE;
                    wMax = wTest;
                end
            end
        end
        w = wMax;
        wResult(i,:) = w;
        lambda = 1.0;
        lossResult(i,1) = Objective(x, w, y, lambda); 
        
        loss = lossResult(i,1)
%         flag2 = abs(lossResultOld - lossResult(i,1));
        MSEN = rssError(y,yTest)/m;
        history.MSEN(i) = MSEN;
        flag1 = MSEN;
        %% 判断当前的w值是否收敛
        if(flag1 <= 0.5 && flag == 0)
            disp('***********************');
            history.myIter = i;
            flag = 1;
%             toc(t_start);
            
        end
    end
    %% MSE均方误差
            history.MSE = rssError(y,yTest)/m;
            %% R2值
            history.R2 = 1 - rssError(y,yTest)/sum((y - mean(y)).^2);
            %% R2Adjusted
            history.R2Adjusted = 1 - (1-history.R2)*(m-1)/(m-n-1);
            history.w = ws';
            
            %% 测试集误差
            [examples,features] = size(testExamples);
            xx = testExamples(:,1:features-1);
            yy = testExamples(:,features);
            yyTest = xx*ws';
            history.testMSE = rssError(yy,yyTest)/m;
            %% R2值
            history.testR2 = 1 - rssError(yy,yyTest)/sum((yy - mean(yy)).^2);
            %% R2Adjusted
            history.testR2Adjusted = 1 - (1-history.testR2)*(examples-1)/(examples-features-1);
end

function loss = Objective(x, w, y, lambda)
    loss = ( 1/2 * sum((x*w - y).^2) + lambda*norm(x,1) );
end