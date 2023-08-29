function [ASA_score,precision_score,CSF_DC,GM_DC,WM_DC] = Syn_ASA(I,seg,GT)

    ncluster=numel(unique(GT));
    int_val=unique(GT);
    for i=1:ncluster
        GT_R(i)=mean(nonzeros(I.*(GT==int_val(i))));
        Seg_R(i)=mean(nonzeros(I.*(seg==i)));
    end
    [~,GT_ind]=sort(GT_R,'descend');
    [~,Seg_ind]=sort(Seg_R,'descend');

    %% Performance measure ASA
    int_val=unique(GT);
    S_sum=[];

    for i=1:ncluster
        A=(GT==int_val(i));
        
        [~,index]=max([dice(A,(seg==1)),dice(A,(seg==2)),dice(A,(seg==3)),dice(A,(seg==4))]);
        B=(seg==index);
        Seg_true_sum(i)=numel(nonzeros(bitand(A,B)));%对于聚类i正确聚类的个数
        GT_sum(i)=numel(nonzeros(A)); %groundtrue中聚类i的个数
        Seg_sum(i)=numel(nonzeros(B));%分割结果中聚类i的个数
        if i==2
            CSF_DC=2*Seg_true_sum(i)/(numel(nonzeros(A))+numel(nonzeros(B)));
        end
        if i==3
            GM_DC=2*Seg_true_sum(i)/(numel(nonzeros(A))+numel(nonzeros(B)));
        end
        if i==4
            WM_DC=2*Seg_true_sum(i)/(numel(nonzeros(A))+numel(nonzeros(B)));
        end
    end
    ASA_score=sum(Seg_true_sum(1:ncluster))/sum(GT_sum(1:ncluster));
    pi = 0;
    for i=1:ncluster
        pi = pi + Seg_true_sum(i)/Seg_sum(i);
    end
    precision_score=pi/ncluster;
end