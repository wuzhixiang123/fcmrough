% Written by Haonan Liu, Revised by Yuxuan Zhang
% If you use this code, please cite the paper--Xiangzhi Bai,Yuxuan Zhang, Haonan Liu, and Yingfan Wang,
%" Intuitionistic Center-Free FCM Clustering for MR Brain Image Segmentation"
% IEEE Journal of Biomedical and Health Informatics, 2018
%Date of Publication: 30 November 2018 
%DOI: 10.1109/JBHI.2018.2884208
% If you have any questions, feel free to contact me(zhangyuxuan1996@buaa.edu.cn)
% Also, feel free to make modifications on it
% By the way, the dataset in the pacakage is the preprocessed data from https://www.nitrc.org/projects/ibsr
% If you use the corresponding data, please cite related papers about the IBSR dataset.
%% 
close all;
clear
clc
% str1 = '..\data\brain\';%原始图像的位置
str1 = '..\data\brainweb\';%原始图像的位置
% str2 = '..\data\seg\'; %groundtrue的位置
str2 = '..\data\segbrainweb\'; %groundtrue的位置

str3 = '..\data\brainweb\';
str4 = '..\data\segbrainweb\';

str6 = '..\result3\';
% 打开一个文本文件以写入 ASA 结果
fileID = fopen('ASA_results.txt', 'w');
file_I = dir(fullfile(str1, '*.bmp'));  % 列出所有以 .bmp 结尾的文件
file_GT = dir(fullfile(str2, '*.bmp'));  % 列出所有以 .bmp 结尾的文件
for i = 1:numel(file_I)
    file_I_name = file_I(i).name;  % 获取文件名
    file_I_path = fullfile(str1, file_I_name);  % 构建完整的文件路径
    file_GT_name = file_GT(i).name;  % 获取文件名
    file_GT_path = fullfile(str2, file_GT_name);  % 构建完整的文件路径
    fprintf('CRFCM: deal with the %d  image, %d images remaining\n',i,679-i);
    tic
    I = double(imread(file_I_path));  % 读取图片
    GT = double(imread(file_GT_path));  % 读取图片groundtrue
    % I=double(imread([str1,'t1_0_0_z',num2str(i),'.bmp']));
    % GT=double(imread([str2,'t1_0_0_z',num2str(i),'.bmp']));
    [height,width]=size(I);
    IMG_data=reshape(I,[],1);
    [V,U]=fcm(IMG_data,4);         
    [V,cidx]=sort(V);
    U=U(cidx,:);
    [label]=ICFFCM(I,4,U,2.5,400,3);
    label=label';
    IMG_data(label==1)=0;
    IMG_data(label==2)=84;
    IMG_data(label==3)=171;
    IMG_data(label==4)=255;
    seg=reshape(label,height,width);%这里面保存标签值
    result=reshape(IMG_data,height,width);%将分割后的标签赋予灰度值保存起来
    imwrite(uint8(result),[str6,num2str(i),'.bmp']);
    toc
    [ASA_score,precision_score,CSF_DC,GM_DC,WM_DC]=Syn_ASA(I,seg,GT);


    % 逐个样本写入 ASA 结果到文本文件中
    fprintf(fileID, '样本 %d 的 ASA 值是 %.4f,precision是%.4f,CSF_DC,GM_DC,WM_DC分别是%.4f,%.4f,%.4f\n', i,ASA_score,precision_score,CSF_DC,GM_DC,WM_DC);
end
% 关闭文本文件
fclose(fileID);