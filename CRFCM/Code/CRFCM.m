% This function runs slow, further modifications on it would be released in the furture.
function label=CRFCM(IMG,C,U,a,sigma,alpha)
tic
[height,width]=size(IMG);
N=height*width;
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
%m是本来就有的参数，下面是新的
m=2;
w_low=0.6;
w_upper=0.4;

toc
RHO=zeros(C,N);  %用来存储样本和类的关系ρij，也即是论文中的ηij
t=0;
L=zeros(C,N);
L3d=reshape(L',height,width,C);
L_no=reshape(L',height,width,C);%记录损失中没有加权时的那部分
%计算W矩阵：
W_all=zeros(N,N);
lower_W_matrices = cell(C, 1);
edge_W_matrices = cell(C, 1);
for k=1:N
    Wg=exp(-((X-X(k))./H).^2);
    Wx=abs(coor_x_data-coor_x_data(k));
    Wy=abs(coor_y_data-coor_y_data(k));
    Ws=exp(-(sqrt(Wx.^2+Wy.^2))./sigma);
    W=Wg.*Ws;
    W_all(:,k)=W;
end
while(t<100)
    disp(t)
    %先计算阈值再计算每个类的上、下近似以及边缘的样本号，再得到每个类的核心样本和边缘样本的隶属度
    str1 = '计算近似';
    disp(str1);
    [lower_approx_matrix, edges_matrix, lower_approx_samples, upper_approx_samples, edges_samples,threshold] = calculate_approximations(U);
    disp(str1);
    str2 = '计算核心边缘W矩阵';
    disp(str2);
    
%     local_W_all = gpuArray(W_all);
%     lower_approx_samples = gpuArray(single(lower_approx_samples));
%     lower_W_matrices = gpuArray(single(lower_W_matrices));
%     edges_samples = gpuArray(single(edges_samples));
%     edge_W_matrices = gpuArray(single(edge_W_matrices));
    for cluster = 1:C
        lower_approx_samples_cluster = lower_approx_samples{cluster};
        lower_W_matrix = W_all(lower_approx_samples_cluster, :);
        lower_W_matrices{cluster} = lower_W_matrix;
    end
%     lower_W_matrices = generate_lower_W_matrices(W_all, lower_approx_samples);
    for cluster = 1:C
%         local_W_all = gpuArray(W_all);
        edges_samples_cluster = edges_samples{cluster};
        edge_W_matrix = W_all(edges_samples_cluster, :);
        edge_W_matrices{cluster} = edge_W_matrix;
    end
%     lower_W_matrices = gather(lower_W_matrices);
%     edge_W_matrices = gather(edge_W_matrices);
%     edge_W_matrices = generate_edge_W_matrices(W_all, edges_samples);
    disp(str2);
%     RHO = calculate_relation_clustertopoint(lower_approx_matrix, lower_W_matrices,edges_matrix,edge_W_matrices,m,w_low,w_upper);
% 使用gpu计算
    str3 = '计算类和样本关联';
    disp(str3);
    RHO = calculate_relation_clustertopoint(lower_approx_matrix, lower_W_matrices,edges_matrix,edge_W_matrices,m,w_low,w_upper);
    disp(str3);
    %Uxing=1-(1-U.^a).^(1/a);
%     for k=1:N
%         RHO(:,k)=((Uxing.^2)*W_all(:,k))./sum((Uxing.^2),2); %得到样本k和所有类的ρ
%     end
    U3d=reshape(U',height,width,C);
    RHO3d=reshape(RHO',height,width,C);
    for i=1:C
        L_no(:,:,i)=(U3d(:,:,i).^m).*(RHO3d(:,:,i).^(-2));
    end
    str4 = '损失';
    disp(str4);
    L3d=calculate_losses(L_no, W_all,C,height,width,N,alpha);
    disp(str4);
%     for i=1:C
%          L3d(:,:,i)=imfilter(((U3d(:,:,i).^2).*(RHO3d(:,:,i).^(-2))),[alpha/8 alpha/8 alpha/8;alpha/8 0 alpha/8;alpha/8 alpha/8 alpha/8]);
%     end
    L_d=reshape(L3d,N,C);
    L=L_d';
    Ufenzi=(RHO.^(-2)+L).^(-1/(m-1));  %保存的时跟新μ分子的值
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