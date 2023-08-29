function losses = calculate_losses(L_no, W_all,C,height,width,N,alpha)
    % 初始化损失矩阵 这个alpha就是β
    L=zeros(C,N);
    losses=reshape(L',height,width,C);
    loss = zeros(height, width);
   
    % 定义8个相邻样本的偏移量
    offsets = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];
    for cluster=1:C
        
        for i = 1:height
            for j = 1:width
                % 获取当前样本的关联权值和
                weight_sum = 0;
                neighbor_sum = 0;
                   %计算样本号
                sample = (j-1)*height+i;
                for k = 1:8
                    % 计算相邻样本的坐标
                    ni = i + offsets(k, 1);
                    nj = j + offsets(k, 2);
                    %计算样本号
                    next = (nj-1)*height+ni;
                    % 检查相邻样本的坐标是否在有效范围内
                    if ni >= 1 && ni <= height && nj >= 1 && nj <= width
                        % 获取相邻样本与当前样本的关联权值
                        weight = W_all(next, sample);

                        % 累加权值和
                        weight_sum = weight_sum + weight;

                        % 累加相邻样本的值乘以权值
                        neighbor_sum = neighbor_sum + L_no(ni, nj,cluster) * weight*alpha;
                    end
                end

                % 计算当前样本的损失值
                if weight_sum > 0
                    loss(i, j) = neighbor_sum / weight_sum;
                else
                    % 如果权值和为0，则当前样本的损失值也设为0
                    loss(i, j) = 0;
                end
            end
        end
        losses(:,:,cluster)=loss;
    end
end
