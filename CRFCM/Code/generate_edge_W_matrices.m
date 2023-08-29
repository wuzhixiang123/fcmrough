%在一个U生成的边缘下，每个类都得到表示每个样本与该类的边缘样本之间的关联W
function edge_W_matrices = generate_edge_W_matrices(W_all, edges_samples)
    % W_all: N*N的矩阵
    % lower_approx_samples: 包含每个类下近似样本号的cell数组
    
    C = numel(edges_samples);
    edge_W_matrices = cell(C, 1);
    
    for cluster = 1:C
        edges_samples_cluster = edges_samples{cluster};
        edge_W_matrix = W_all(edges_samples_cluster, :);
        edge_W_matrices{cluster} = edge_W_matrix;
    end
end
