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
str1 = '..\data\brain\';
str2 = '..\result\';
for i=1:679
fprintf('ICFFCM: deal with the %d  image, %d images remaining\n',i,679-i);
tic
I=double(imread([str1,num2str(i),'.bmp']));
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
result=reshape(IMG_data,height,width);
imwrite(uint8(result),[str2,num2str(i),'.bmp']);
toc
end