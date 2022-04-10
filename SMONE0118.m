function [Archive,novelty_threshold,Parents] = SMONE0118(Parents,D,Archive,novelty_threshold,nnstruct,Parameter)
%------------------------------- Reference --------------------------------
%  Vargas D V, Murata J, Takano H, et al. General subpopulation framework 
%  and taming the conflict inside populations[J]. Evolutionary computation, 
%  2015, 23(1): 1-36.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Parameter setting
    if nargin > 5
        [CR,F] = deal(Parameter{:});
    elseif nargin == 4
        novelty_threshold = [];
        [CR,F] = deal(0.6,0.1); %1029-0.2,0.1/0.5,0.1 good /0.9,0.1
    else
        [CR,F] = deal(0.6,0.1); %1029-0.2,0.1/0.5,0.1 good /0.9,0.1
    end
    subnum = size(Parents,1); %3个子种群
    Parent_set = Parents{subnum}; %取出最后一个个种群
    Parentnum = size(Parent_set,2); %这个子种群的个体数//=4,j遍历
    if isa(Parent_set(1),'INDIVIDUAL')%取出第indx个种群的第一个元素，判断是不是个体
        calObj  = true;
    else
        calObj = false;
    end
    Global = GLOBAL.GetObj();
    %% Differental evolution 
    for j =1:Parentnum
        %Mutation 交叉操作
        Trial_vector = mutationOper(Parents,F,subnum); %这里的offspring就是老师的trial vector
        %限制
        Lower = repmat(Global.lower,1,1);
        Upper = repmat(Global.upper,1,1);
        Trial_vector  = min(max(Trial_vector,Lower),Upper); 
        
        %Crossover 变异操作
        parent_vector = Parent_set(j);
        Trial_vector = CrossOper(D,Trial_vector,parent_vector,CR);
        
        %individual 类型转换
        if calObj
        Trial_vector = INDIVIDUAL(Trial_vector);
        end
        
        %select
        k = 5;%1029-10%1114-5
        na = 40;% 个体数少-100，个体数多-50
        
        
        %0608修改
        flag = 0;
        for i = 1:Global.M
            if parent_vector.obj(i)>Trial_vector.obj(i)
                flag = 1;
            end
        end
        if flag == 1 
        %这里有两种_____________________________________________________________
        if Parentnum < k
            distvect(j) = disKNN4(parent_vector,Parent_set,subnum,Parentnum,nnstruct); %计算到多个目标的最小距离
            trial_threshold = disKNN4(Trial_vector,Parent_set,subnum,Parentnum,nnstruct);%不能用k，只能用popnum=4
        else
            distvect(j) = disKNN4(parent_vector,Parent_set,subnum,k,nnstruct); %计算到多个目标的最小距离
            trial_threshold = disKNN4(Trial_vector,Parent_set,subnum,k,nnstruct);%不能用k，只能用popnum=4
        end
        
        if trial_threshold > distvect(j)
            Parent_set(j) = Trial_vector;
            %是否在输出的档案中做积累
            [new_vector,novelty_threshold] = addArchivee(Archive{3},Trial_vector,novelty_threshold,k,subnum,[],nnstruct);
            Archive{2} = [Archive{2},new_vector];
            Archive{3} = [Archive{3},new_vector];
        end
        end
        %循环与输出
        Parents{subnum} = Parent_set;
    end
end

function dist = disKNN4(Trial_vector,Archive,subnum,k,nnstruct)
    triOut = RBF_predictor(nnstruct.W,nnstruct.B,nnstruct.Centers,nnstruct.Spreads,Trial_vector.decs);
    triError = abs(Trial_vector.objs - triOut) ;
    for j =1:size(Archive,2)%遍历Archive中的个体
        nearest_neighbors_distance(j)= 0;
        sum1 = 0;
        Parent_set = Archive(j);
        OldOut = RBF_predictor(nnstruct.W,nnstruct.B,nnstruct.Centers,nnstruct.Spreads,Parent_set.decs);
        OldError = abs(Parent_set.objs - OldOut) ;

        for m =1:subnum-2 %遍历两个目标
            sum1 = sum1+(triError(m)-OldError(m))^2;
        end
        nearest_neighbors_distance(j)=sqrt(sum1);
    end
    
    %sorting nearest neighbors
	Rankneighbor= sort(nearest_neighbors_distance);
    
    %k个最小距离（平均）
    dist = sum(Rankneighbor(1:k))/k; %累加,这个地方的数量要注意              
end

