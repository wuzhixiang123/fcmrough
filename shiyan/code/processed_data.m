function processed_data(filename,filenameground,name,num)
%将1、2、3类的数据做归一处理，其余为0
% processed_data('t1_icbm_normal_1mm_pn0_rf0.rawb','train.txt',90)
mark=Mark(filenameground,num);
read=readrawb(filename, num);
[row,col]=size(read);
read_new = zeros(row,col);
for i=1:row   %行
    for j=1:col    %列
        if mark(i,j)==0
            read_new(i,j)=0;
        else
            read_new(i,j)=read(i,j)./255;   %将第0、1、2、3、8类拿出来，其余类为0
        end
    end
end
Write_txt(name,read_new);    %将数据写入TXT文件