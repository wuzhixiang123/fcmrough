function relation_clustertopoint = calculate_relation_clustertopoint(lower_approx_matrix, lower_W_matrices,edges_matrix,edge_W_matrices,m,w_low,w_upper)
    % lower_approx_matrix: 这是一个cell对于一个特定的类表示这个类和该类核心样本的隶属度
    % lower_W_matrices: 这是一个cell对于一个特定的类表示该类的核心样本和所有样本的关系
    %两者结合表示这个类和所有样本间的关联ρ
    %后面俩是针对边缘样本的
    C = numel(lower_approx_matrix);
    N = size(lower_W_matrices{1}, 2);
    %记录结果ρ的矩阵C*N
    relation_clustertopoint = zeros(C, N);
%     relation_lower = zeros(C, N);
%     relation_edges = zeros(C, N);
    for cluster = 1:C
         % 获取当前类的下近似隶属度向量，以及边缘的
            U_lower = lower_approx_matrix{cluster};
            U_edges = edges_matrix{cluster};
 
        if ~isempty(U_lower) && ~isempty(U_edges)
            % 获取当前类的下近似矩阵,以及边缘的
            lower_W_matrices_cluster = lower_W_matrices{cluster};
            edge_W_matrices_cluster = edge_W_matrices{cluster};
            % 将隶属度向量与矩阵进行逐元素相乘得到核心的ρ，以及边缘的
            result_lower_vector = ((U_lower.^m)*lower_W_matrices_cluster)./sum((U_lower.^m),2);
            result_edges_vector = ((U_edges.^m)*edge_W_matrices_cluster)./sum((U_edges.^m),2);
            result_vector = w_low*result_lower_vector+w_upper*result_edges_vector;
%             fprintf('聚类%d的核心的lishudu：',cluster);
%             disp(U_lower);
%             fprintf('聚类%d的核心的W juzheng：',cluster);
%             disp(lower_W_matrices_cluster);
%             fprintf('聚类%d核心的ρroushi：',cluster);
%             disp(result_lower_vector);
%             fprintf('聚类%d的边缘的lishudu：',cluster);
%             disp(U_edges);
%             fprintf('聚类%d的边缘的W juzheng：',cluster);
%             disp(edge_W_matrices_cluster);
%             fprintf('聚类%d边缘的ρroushi：',cluster);
%             disp(result_edges_vector);
%             fprintf('聚类%d总的的ρroushi：',cluster);
%             disp(result_vector);
            %将结果存储到relation_clustertopoint
            relation_clustertopoint(cluster,:)=result_vector;
        elseif isempty(U_edges) && ~isempty(U_lower)
            %只要获取核心即可
            lower_W_matrices_cluster = lower_W_matrices{cluster};
            result_lower_vector = ((U_lower.^m)*lower_W_matrices_cluster)./sum((U_lower.^m),2);
            result_vector = result_lower_vector;
            %将结果存储到relation_clustertopoint
            relation_clustertopoint(cluster,:)=result_vector;   
        elseif ~isempty(U_edges) && isempty(U_lower)
            %只要获取边缘即可
            edge_W_matrices_cluster = edge_W_matrices{cluster};
            result_edges_vector = ((U_edges.^m)*edge_W_matrices_cluster)./sum((U_lower.^m),2);
            result_vector = result_edges_vector;
            relation_clustertopoint(cluster,:)=result_vector;
        else
            disp("error");
            % 如果 edges_matrix{cluster} 和 lower_approx_matrix{cluster} 均为空，则执行其他操作
              % 这里可以根据需要进行处理
        end
    end
end
