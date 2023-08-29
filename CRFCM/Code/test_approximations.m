function test_approximations()
    % 生成随机的隶属度矩阵
     C = 3; % 聚类数目
%     N = 10; % 样本数
%     U = rand(C, N); % 随机生成隶属度矩阵
    U = [0.4,0.1,0.2,0.7,0.8;
        0.3,0.2,0.7,0.1,0.1;
        0.3,0.7,0.1,0.2,0.1;
        ];
    W_all = [1 0.6 0.8 0.4 0.2;
             0.6 1 0.7 0.6 0.5;
             0.8 0.7 1 0.5 0.4;
             0.4 0.6 0.5 1 0.3;
             0.2 0.5 0.4 0.3 1];
    % 设定阈值 a
    a = 0.4;
    m = 2;
    w_low = 0.6;
    w_upper = 0.4;
    % 计算下近似、上近似以及边缘样本号
   [lower_approx_matrix, edges_matrix, lower_approx_samples, upper_approx_samples, edges_samples,threshold] = calculate_approximations(U);
   fprintf('阈值是：\n');
   disp(threshold);
    % 输出每个聚类的下近似和边缘样本号
    for cluster = 1:C
        fprintf('聚类 %d 的下近似：\n', cluster);
        disp(lower_approx_samples{cluster});
        fprintf('聚类 %d 的下近似隶属度：\n', cluster);
        disp(lower_approx_matrix{cluster});
%         fprintf('聚类 %d 的上近似：\n', cluster);
%         disp(upper_approx_samples{cluster});
        
        fprintf('聚类 %d 的边缘：\n', cluster);
        disp(edges_samples{cluster});
        fprintf('聚类 %d 的边缘隶属度：\n', cluster);
        disp(edges_matrix{cluster});
        
        fprintf('\n');
    end
    edge_W_matrices = generate_edge_W_matrices(W_all, edges_samples);
    fprintf('聚类1的边缘W');
    disp(edge_W_matrices{1});
    lower_W_matrices = generate_lower_W_matrices(W_all, lower_approx_samples);
    fprintf('聚类1的核心W');
    disp(lower_W_matrices{1});
    result_lower_vector = ((lower_approx_matrix{1}.^2)*lower_W_matrices{1})./sum((lower_approx_matrix{1}.^2),2);
    fprintf('聚类1的核心的ρ：');
    disp(result_lower_vector);
    result_edges_vector = ((edges_matrix{1}.^2)*edge_W_matrices{1})./sum((edges_matrix{1}.^2),2);
    fprintf('聚类1的边缘的ρ：');
    disp(result_edges_vector);
    result_vector = w_low*result_lower_vector+w_upper*result_edges_vector;
    fprintf('聚类1的的ρ：');
    disp(result_vector);
    
    relation_clustertopoint = calculate_relation_clustertopoint(lower_approx_matrix, lower_W_matrices,edges_matrix,edge_W_matrices,m,w_low,w_upper);
    disp(relation_clustertopoint);
end