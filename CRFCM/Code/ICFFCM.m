% This function runs slow, further modifications on it would be released in the furture.
function label=ICFFCM(IMG,C,U,a,sigma,alpha)
tic
[height,width]=size(IMG);
N=height*width;
% disp(height);
% disp(width);
coor=zeros(height,width,2); 
for i=1 : height
    for j= 1 : width
        coor(i,j,1)=i;
        coor(i,j,2)=j;
    end
end
coor_data=reshape(coor,[],2);
coor_x_data=coor_data(:,1);
coor_y_data=coor_data(:,2);

X=reshape(IMG,[],1);

v=sum(X)/N;
d=abs(X-v);
d_avg=sum(d)/N;
h=abs(d-d_avg);
H=sum(h)/N;
toc
RHO=zeros(C,N);  %用来存储样本和类的关系ρij，也即是论文中的ηij
t=0;
L=zeros(C,N);
L3d=reshape(L',height,width,C);
while(t<100)  
    disp(t);
    Uxing=1-(1-U.^a).^(1/a);
%     disp(t);
    for k=1:N
    Wg=exp(-((X-X(k))./H).^2);
    Wx=abs(coor_x_data-coor_x_data(k));
    Wy=abs(coor_y_data-coor_y_data(k));
    Ws=exp(-(sqrt(Wx.^2+Wy.^2))./sigma);
    W=Wg.*Ws;
    RHO(:,k)=((Uxing.^2)*W)./sum((Uxing.^2),2); %得到样本k和所有类的ρ
    end
    U3d=reshape(Uxing',height,width,C);
    RHO3d=reshape(RHO',height,width,C);
    for i=1:C
        % 下面这个L3d保存的是更新μ的后面那个损失项的值。特定i下为特定类下与所有样本间的关系。        
        L3d(:,:,i)=imfilter(((U3d(:,:,i).^2).*(RHO3d(:,:,i).^(-2))),[alpha/8 alpha/8 alpha/8;alpha/8 0 alpha/8;alpha/8 alpha/8 alpha/8]);
    end
    L_d=reshape(L3d,N,C);
    L=L_d';
    Ufenzi=(RHO.^(-2)+L).^(-1);  %保存的时跟新μ分子的值
    CSUfenzi=sum(Ufenzi);
    Unew=(Ufenzi)./CSUfenzi(ones(C,1),:);
   
epsilon=max(max(abs(Unew-U)));
if epsilon<0.001 
    break;
else
    U=Unew;
end
    t=t+1;
end
[~,label]=max(Unew);
end