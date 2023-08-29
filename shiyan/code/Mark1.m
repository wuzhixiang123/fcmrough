% 去除颅骨的掩码矩阵
function mark1=Mark1(filename,num)
fp=fopen(filename);
temp=fread(fp, 181 * 217 * 181);
image=reshape(temp, 181 * 217, 181);  
images=image(:, num);
images=reshape(images, 181, 217);
mark_data=images;
fclose(fp);
%将第0、1、2、3类标签所在的坐标点拿出来，其余置0
[row,col] = size(mark_data);
mark1 = zeros(row,col);
for i=1:row
    for j=1:col
        if (mark_data(i,j)==5)||(mark_data(i,j)==6)||(mark_data(i,j)==7)||(mark_data(i,j)==8)||(mark_data(i,j)==4)||(mark_data(i,j)==9)
            mark1(i,j)=0;
        else
            mark1(i,j)=mark_data(i,j);
           
        end
    end
end
end