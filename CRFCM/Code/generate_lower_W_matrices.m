%在一个U生成的下近似下，每个类都得到表示每个样本与该类的核心样本之间的关联W
function lower_W_matrices = generate_lower_W_matrices(W_all, lower_approx_samples)
    % W_all: N*N的矩阵
    % lower_approx_samples: 包含每个类下近似样本号的cell数组
    
    C = numel(lower_approx_samples);
    lower_W_matrices = cell(C, 1);
    
    for cluster = 1:C
        lower_approx_samples_cluster = lower_approx_samples{cluster};
        lower_W_matrix = W_all(lower_approx_samples_cluster, :);
        lower_W_matrices{cluster} = lower_W_matrix;
    end
end
