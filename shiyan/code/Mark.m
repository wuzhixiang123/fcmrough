%将标签为1、2、3类分出来，其余为0，mark取值：0、1、2、3
%0=Background,背景
% 1=CSF,脑脊液
% 2=Grey Matter,灰质
% 3=White Matter,白质
% 4=Fat,脂肪
% 5=Muscle/Skin,肌肉/皮肤
% 6=Skin,皮肤
% 7=Skull,颅骨
% 8=Glial Matter,胶质
% 9=Connective,连接
%[mark_new,mark]=Mark('phantom_1.0mm_normal_crisp.rawb',90);
% Mark(str3,90)
function mark=Mark(filename,num)
fp=fopen(filename);
temp=fread(fp, 181 * 217 * 181);
image=reshape(temp, 181 * 217, 181);  
images=image(:, num);
images=reshape(images, 181, 217);
mark_data=images;
fclose(fp);
%将第0、1、2、3类标签所在的坐标点拿出来，其余置0
[row,col] = size(mark_data);
mark = zeros(row,col);
for i=1:row
    for j=1:col
        if (mark_data(i,j)==1)||(mark_data(i,j)==2)||(mark_data(i,j)==3)
            mark(i,j)=mark_data(i,j);
        else
            mark(i,j)=0;
        end
    end
end
end