function init_image(filename,num,save_path)
pic_type='.bmp';
% 函数init_image(filename,num)中的第一个参数filename是欲读取的rawb文件的文件名，第二个参数num就是第多少张。输出为原始图像，未处理
%例如：init_image('t1_icbm_normal_1mm_pn0_rf0.rawb','train.txt',90)， init_image('phantom_1.0mm_normal_csf.rawb','train.txt',90)
read=readrawb(filename, num);
% 旋转90°并显示出来
read=imrotate(read, 90);                                       
imshow(uint8(read));
%imageid表示图片的名称包括噪声灰度不均匀、哪个平面的第几张图片
imageid = sprintf('t1_3_20_z%d',num);
imwrite(uint8(read),strcat(save_path,imageid,pic_type));
end