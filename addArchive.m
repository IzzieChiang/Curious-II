function [new_vector,novelty_threshold] = addArchive(Archive,Trial_vector,novelty_threshold,k,obj)
    na = 40; %论文=1，code = 4 感觉这个数字是为了抽样
    %①有obj，是单目标子种群
    if isempty(obj)==0 
    %前面几个较少的
        if size(Archive,2)<k
            new_vector = Trial_vector;        
        elseif novelty_threshold <0.0001
            novelty_threshold = disKNNmin(Trial_vector.obj,Archive,k,obj);
            new_vector = Trial_vector;                       
        else %当Archive中个体较多了
            trial_threshold = disKNNmin(Trial_vector.obj,Archive,k,obj);
            if novelty_threshold < trial_threshold
                if size(Archive,2) > na
                    novelty_threshold = novelty_threshold*1.1;%1.1——两种dist的时候1.01使其密集
                end
                new_vector = Trial_vector;                
            else
                novelty_threshold = novelty_threshold*0.999;  %0.999
                new_vector = [];  
            end
        end
    %②obj=[]，是MONA子种群    
    else 
        if size(Archive,2)< k
            new_vector = Trial_vector;          
        elseif novelty_threshold <0.0001
            novelty_threshold = disKNNmin(Trial_vector.obj,Archive,k,obj);
            new_vector = Trial_vector;   
        else %当Archive中个体较多了
            trial_threshold = disKNNmin(Trial_vector.obj,Archive,k,obj);
            if novelty_threshold < trial_threshold
                if size(Archive,2) > na
                    novelty_threshold = novelty_threshold*1.1;
                end
                new_vector = Trial_vector;                        
            else
                novelty_threshold = novelty_threshold*0.999;     %0.999
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
function dist = disKNNmin(Trial_obj,Archive,k,obj)
% 取最小的k个个体的距离
    if isempty(obj)==0 %有obj，是单目标子种群
        Archiveobjs = Archive.objs;
        sum1 = (Trial_obj(obj)-Archiveobjs(:,obj)).^2;
        nearest_neighbors_distance = sqrt(sum1);
    else
        Archiveobjs = Archive.objs;
        sum2 = sum((Trial_obj-Archiveobjs).^2,2);
        nearest_neighbors_distance = sqrt(sum2);
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