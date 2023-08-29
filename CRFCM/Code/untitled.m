
    % lower_approx_matrix: 这是一个cell对于一个特定的类表示这个类和该类核心样本的隶属度
    % lower_approx_matrices: 这是一个cell对于一个特定的类表示该类的核心样本和所有样本的关系
    %两者结合表示这个类和所有样本间的关联ρ

    C = 3;
    N = 4;
    
    relation_clustertopoint = zeros(C, N);
    
    for cluster = 1:C
        % 获取当前类的下近似隶属度向量
        lower_approx_vector = [1,2,3,4];
        
        % 获取当前类的下近似矩阵
        lower_approx_matrix_cluster = [[0,1]
            [1,2]
            [1,2]
            [2,3]];
        
        % 将隶属度向量与矩阵进行逐元素相乘
        result_vector = lower_approx_vector .* lower_approx_matrix_cluster;
        
        % 将结果向量存储到relation_clustertopoint矩阵的对应行中
        relation_clustertopoint(cluster, :) = result_vector;
    end
end
