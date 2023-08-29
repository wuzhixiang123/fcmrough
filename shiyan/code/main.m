%图片处理
str1_3_20 = '..\data\t1_3_20.rawb';
str1_0_0 = '..\data\t1_0_0.rawb';
% 保存初始的图片
str2 = '..\data\origin\t1_0_0\';
str3 = '..\data\phantom_1.0mm_normal_crisp.rawb';
str4 = '..\data\Ground\t1_0_0\';
% 保存去除颅骨的
str5 = '..\data\origin_1\';
%这个才是产生实验原始图片的
origin(str1_0_0,str3,str2,100)
% 这个才是ground truth
Ground(str3,str4,100);
% init_image(str1, 90,str2);
% init_image_1(str1,str3,str5,90);
% ground_truth(str1,str3,str4,train.txt,90);
%批量操作：
% for i=1:181
%     read{i}=readrawb(str1, i);
%     read{i}=imrotate(read{i}, 90); 
%     % imshow(uint8(read{i}));
%     %imageid表示图片的名称包括噪声灰度不均匀、哪个平面的第几张图片
%     imageid = sprintf('t1_3_20_z%d',i);
%     imwrite(uint8(read{i}),[str2, imageid, '.bmp']);
% end
% save image_data read








