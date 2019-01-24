function [arrayResult]= tu(dirName, fileObjectiveName)
p1 = mfilename('fullpath');
i = findstr(p1,'\');
pPath = p1(1:i(end));
pPath = [pPath, dirName, '\'];
maxIter = 200;

file_list = ScanDir(pPath, fileObjectiveName);
len = length(file_list);

arrayResult = zeros(maxIter,len);
arrayResult(:,1) = 1:1:maxIter;
disp(arrayResult(:,1));
for index = 1:len
    name = file_list(index);
    cd(pPath);
    disp(name{1})
    data = load(name{1});
    disp(size(data));
    x = data(:,1);
    y = data(:,2);
    [m,n] = size(x);
    
    arrayResult(1:m,index+1) = y;
    arrayResult(m+1:maxIter,index+1) = y(m);
    
end

end
%% 函数功能：指定路径path下所有图像路径，不扫描子文件夹
% path：查找的路径
% file_mask：需要查找的文件类型，比如*.jpg
function file_list = ScanDir(path, file_mask)
file_path =  path;  % 图像文件夹路径
img_path_list = dir(strcat(file_path, file_mask)); % 获取该文件夹中所有jpg格式的图像
% disp(img_path_list);
img_num = length(img_path_list);    % 获取图像总数量
file_list = cell(img_num, 1);
if img_num > 0 %有满足条件的图像
    for j = 1:img_num %逐一读取图像
        image_name = img_path_list(j).name;% 图像名
%         fprintf('当前找到指定的文件 %s\n', strcat(file_path,image_name));% 显示扫描到的图像路径名
        file_list{j} = image_name;
    end
end
end