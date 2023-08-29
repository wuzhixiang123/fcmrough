function Ground(filenameground,save_path,num)
% 函数main(filename, num)中的第一个参数filename是欲读取的rawb文件的文件名，第二个参数num就是第多少张。
%例如：main('t1_icbm_normal_1mm_pn0_rf0.rawb','train.txt',90)， main('phantom_1.0mm_normal_csf.rawb','train.txt',90)
mark=Mark(filenameground,num);
% 假设 mark 矩阵中有 0、1、2、3 这些值
% 创建一个新的矩阵，与 mark 大小相同，用于保存映射后的灰度值
grayImage = zeros(size(mark));

% 使用条件语句和索引映射值
grayImage(mark == 0) = 0;   % 将 mark 中值为 1 的位置赋值为灰度值 0
grayImage(mark == 1) = 84;  % 将 mark 中值为 2 的位置赋值为灰度值 84
grayImage(mark == 2) = 171; % 将 mark 中值为 3 的位置赋值为灰度值 171
grayImage(mark == 3) = 255; % 将 mark 中值为 0 的位置赋值为灰度值 255

% 旋转90°并显示出来
grayImage=imrotate(grayImage, 90);                                       
imshow(uint8(grayImage));
pic_type='.bmp';
imageid = sprintf('t1_0_0_z%d',num);
imwrite(uint8(grayImage),strcat(save_path,imageid,pic_type));
end