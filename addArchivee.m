function [new_vector,novelty_threshold] = addArchivee(Archive,Trial_vector,novelty_threshold,k,subnum,obj,nnstruct)
    na = 40; %论文=1，code = 4 感觉这个数字是为了抽样
    %①有obj，是单目标子种群
    if isempty(obj)==0 
    %前面几个较少的
        if size(Archive,2)<k
            new_vector = Trial_vector;        
        elseif novelty_threshold <0.0001
            novelty_threshold = disKNNmin(Trial_vector,Archive,subnum,k,obj,nnstruct);
            new_vector = Trial_vector;                       
        else %当Archive中个体较多了
            trial_threshold = disKNNmin(Trial_vector,Archive,subnum,k,obj,nnstruct);
            if novelty_threshold < trial_threshold
                if size(Archive,2) > na
                    novelty_threshold = novelty_threshold*1.01;%1.1
                end
                new_vector = Trial_vector;                  
            else
                novelty_threshold = novelty_threshold*0.99;   %0.9999
                new_vector = [];
            end
        end        
    %②obj=[]，是MONA子种群    
    else 
        if size(Archive,2)< k
            new_vector = Trial_vector;        
        elseif novelty_threshold <0.0001
            novelty_threshold = disKNNmin(Trial_vector,Archive,subnum,k,obj,nnstruct);
            new_vector = Trial_vector;  
        else %当Archive中个体较多了
            trial_threshold = disKNNmin(Trial_vector,Archive,subnum,k,obj,nnstruct);
            if novelty_threshold < trial_threshold
                if size(Archive,2) > na
                    novelty_threshold = novelty_threshold*1.1;
                end
                new_vector = Trial_vector;                          
            else
                novelty_threshold = novelty_threshold*0.99;    %0.999
                new_vector = [];
            end
        end        
 
        %{
        n_rejectcounter = n_rejectcounter+1;
        if n_rejectcounter > nrj
            novelty_threshold = novelty_threshold*0.999;
            n_rejectcounter = n_rejectcounter/2;
        end
        %}
                
        
    end
end
    
% 1029
function dist = disKNNmin(Trial_vector,Archive,subnum,k,obj,nnstruct)
% 取最小的k个个体的距离
    triOut = RBF_predictor(nnstruct.W,nnstruct.B,nnstruct.Centers,nnstruct.Spreads,Trial_vector.decs);
    triError = abs(Trial_vector.objs - triOut) ;
    if isempty(obj)==0  %有obj，是单目标子种群
        for j =1:size(Archive,2)%遍历Archive中的个体
            nearest_neighbors_distance(j)= 0;
            % error dist
            Parent_set = Archive(j);
            OldOut = RBF_predictor(nnstruct.W,nnstruct.B,nnstruct.Centers,nnstruct.Spreads,Parent_set.decs);
            OldError = abs(Parent_set.objs - OldOut) ;
            
            sum1 = (triError(obj)-OldError(obj))^2;
            nearest_neighbors_distance(j)=sqrt(sum1);
        end
    else
        for j =1:size(Archive,2)%遍历Archive中的个体
            nearest_neighbors_distance(j)= 0;
            sum2 = 0;
            % error dist
            Parent_set = Archive(j);
            OldOut = RBF_predictor(nnstruct.W,nnstruct.B,nnstruct.Centers,nnstruct.Spreads,Parent_set.decs);
            OldError = abs(Parent_set.objs - OldOut) ;
            
            for m =1:subnum-2 %遍历目标2/n
                sum2 = sum2 + (triError(m)-OldError(m))^2;
            end
            nearest_neighbors_distance(j)=sqrt(sum2);
        end
    end    
    
    %sorting nearest neighbors
	Rankneighbor= sort(nearest_neighbors_distance);
    
    %k个最小距离(平均）
    dist = sum(Rankneighbor(1:k))/k; %累加,这个地方的数量要注意      
end

%1108更新
function dist = disKNNMD(Trial_obj,Archive,k,obj)%马氏距离
% 取最小的k个个体的距离
    if nargin > 4 %有obj，是单目标子种群
        data  = [Trial_obj;Archive.objs];
        dataobj  = data(:,obj);
        D1 = pdist(dataobj,'hamming');
        Z1 = squareform(D1);
        nearest_neighbors_distance = Z1(1,2:end);
        
    else%MONA子种群
        data  = [Trial_obj;Archive.objs];
        D1 = pdist(data,'hamming');
        Z1 = squareform(D1);
        nearest_neighbors_distance = Z1(1,2:end);
    end    
    
    %sorting nearest neighbors
	Rankneighbor= sort(nearest_neighbors_distance);
    
    %k个最小距离(平均）
    dist = sum(Rankneighbor(1:k))/k; %累加,这个地方的数量要注意      
end