% 这个函数产生的才是真正的原始图片只包含四个类
function origin(filename,filenameground,save_path,num)
% 函数main(filename, num)中的第一个参数filename是欲读取的rawb文件的文件名，第二个参数num就是第多少张。
%例如：main('t1_icbm_normal_1mm_pn0_rf0.rawb','train.txt',90)， main('phantom_1.0mm_normal_csf.rawb','train.txt',90)
mark=Mark(filenameground,num);
read=readrawb(filename, num);
[row,col]=size(read);
read_new = zeros(row,col);
for i=1:row   %行
    for j=1:col    %列
        if mark(i,j)==0
            read_new(i,j)=0;
        else
            read_new(i,j)=read(i,j);   %将第0、1、2、3、8类拿出来，其余类为0
        end
    end
end
% 旋转90°并显示出来
read_new=imrotate(read_new, 90);                                       
imshow(uint8(read_new));
pic_type='.bmp';
imageid = sprintf('t1_0_0_z%d',num);
imwrite(uint8(read_new),strcat(save_path,imageid,pic_type));
end