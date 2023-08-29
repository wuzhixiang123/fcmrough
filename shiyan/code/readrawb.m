function g = readrawb(filename, num)
%函数readrawb(filename, num)中的第一个参数filename是欲读取的rawb文件的文件名，第二个参数num就是第多少张。
fid = fopen(filename);
%连续读取181*217*181个数据，这时候temp是一个长度为181*217*181的向量。
%先将rawb中的所有数据传递给temp数组
temp = fread(fid, 181 * 217 * 181);
%然后把它变成了一个181*217*181的数组
images = reshape(temp, 181 , 217, 181);  
%获取图片大小
[xrange, yrange, zrange] = size(images);
%   不同维度（切面）的图的第num张切片
data_volume(1:xrange,1:yrange) = images(:,:,num);
%     data_volume(1:xrange,1:zrange) = images(:,num ,:);
%     data_volume(1:yrange,1:zrange) = images(num,:,:);
g = data_volume;
fclose(fid);
end