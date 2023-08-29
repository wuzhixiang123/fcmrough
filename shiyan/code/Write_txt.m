function Write_txt(name,read)
fp=fopen(name,'w');
[row,col]=size(read);
for i=1:row   %行
    for j=1:col    %列
        if j==col
            fprintf(fp,'%f\n',read(i,j)); 
        else
            fprintf(fp,'%f\t',read(i,j));
        end
    end
end
fclose(fp);