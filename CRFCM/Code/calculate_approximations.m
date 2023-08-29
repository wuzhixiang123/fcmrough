function [lower_approx_matrix, edges_matrix, lower_approx_samples, upper_approx_samples, edges_samples,threshold] = calculate_approximations(U)
    % U: 隶属度矩阵，大小为 C*N，其中 C 是聚类数目，N 是样本数
    % a: 隶属度之差的阈值
    
    C = size(U, 1);
    N = size(U, 2);
    
%     lower_approx = zeros(C, N);
%     upper_approx = zeros(C, N);
    lower_approx_samples = cell(C, 1);
    upper_approx_samples = cell(C, 1);
    edges_samples = cell(C, 1);
    lower_approx_matrix = cell(C, 1);
    edges_matrix = cell(C, 1);
    %sum用于计算分割上下近似的阈值threshold
    sum = 0;
    for i = 1:N
        [sorted_vals, ~] = sort(U(:, i), 'descend');
        % 获取隶属度最大的两个聚类的隶属度值
        max_val1 = sorted_vals(1);
        max_val2 = sorted_vals(2);  
        % 计算隶属度之差
        diff_val = max_val1 - max_val2;
        sum = sum + diff_val;
    end
    threshold = sum/N;
    
    for i = 1:N
        % 对于每个样本找出隶属度值最大的两个聚类
        [sorted_vals, sorted_idx] = sort(U(:, i), 'descend');
        max_cluster1 = sorted_idx(1);
        max_cluster2 = sorted_idx(2);
        
        % 获取隶属度最大的两个聚类的隶属度值
        max_val1 = sorted_vals(1);
        max_val2 = sorted_vals(2);
        
        % 计算隶属度之差
        diff_val = max_val1 - max_val2;
        
        % 根据隶属度之差是否小于 a 进行分类
        if diff_val > threshold
            % 属于隶属度值最大的聚类的下近似，并且也属于这个聚类的上近似
%             lower_approx(max_cluster1, i) = max_val1;
%             upper_approx(max_cluster1, i) = max_val1;
            % 记录上下近似样本号，这个下近似也就是核心
            lower_approx_samples{max_cluster1} = [lower_approx_samples{max_cluster1}, i];
            upper_approx_samples{max_cluster1} = [upper_approx_samples{max_cluster1}, i];
        else
            % 属于这两个聚类的上近似，且不属于两个聚类的下近似
%             upper_approx(max_cluster1, i) = max_val1;
%             upper_approx(max_cluster2, i) = max_val2;
            % 记录上近似样本号
            upper_approx_samples{max_cluster1} = [upper_approx_samples{max_cluster1}, i];
            upper_approx_samples{max_cluster2} = [upper_approx_samples{max_cluster2}, i];
            % 记录边缘样本号（隶属度之差小于 a 的样本），也就是边缘
            edges_samples{max_cluster1} = [edges_samples{max_cluster1}, i];
            edges_samples{max_cluster2} = [edges_samples{max_cluster2}, i];
        end
    end
     for cluster = 1:C
        % 获取当前类的下近似样本号,以及边缘样本号
        samples = lower_approx_samples{cluster};
        samples1 = edges_samples{cluster};
        % 从隶属度矩阵U中提取对应样本号的列，并添加到下近似以及边缘的cell中
        
        %cell一个特定的类，lower_approx_matrix保存的是该类核心样本的隶属度，
        %edges_matrix保存的是该类边缘样本的隶属度
        lower_approx_matrix{cluster} = U(cluster, samples);
        edges_matrix{cluster} = U(cluster, samples1);
        
    end
end
