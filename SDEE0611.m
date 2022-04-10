function [Archive,novelty_threshold,Parents] = SDEE0611(Parents,obj,D,Archive,novelty_threshold,nnstruct,Parameter)
% Subpop中做替换
% Archive中优化创新度
% jDE策略
    %% Parameter setting
    subnum = size(Parents,1); % num of subpop
    Parent_set = Parents{obj}; % select the 'obj' subpop
    parentnum = size(Parent_set,2); %这个子种群的个体数,后面用inii遍历
    t1 = 0.5; %jDE
    t2 = 0.5; %jDE
    FL = 0.1;%jDE
    FU = 0.3;%jDE
    if isa(Parent_set(1),'INDIVIDUAL')%取出第indx个种群的第一个元素，判断是不是个体
        calObj = true;
    else
        calObj = false;
    end
    Global = GLOBAL.GetObj();
    %% Differental evolution     
    for inii = 1:parentnum
        if nargin > 6
            [CR,F] = deal(Parameter{:});
        elseif nargin == 6 
            % 动态自适应
            % 寻找最优个体
            %[fitnessbestX,indexbestX]=min(Parent_set.obj{obj});
            Xobjs = Parent_set.objs;
            [~,indexbestX]=min(Xobjs(:,obj));
            [CR,F] = deal(Parent_set(indexbestX).add{1},Parent_set(indexbestX).add{2});
        end
        %Mutation 变异操作
        R1 = rand();
        R2 = rand();
        if R2 <= t1
            F =  FL + R1*FU;
        end
        Trial_vector = mutationOper(Parents,F,subnum); %这里的offspring就是老师的trial vector
        %限制
        Lower = repmat(Global.lower,1,1);
        Upper = repmat(Global.upper,1,1);
        Trial_vector  = min(max(Trial_vector,Lower),Upper); 
        
        %Crossover 交叉操作
        R3 = rand();
        R4 = rand();
        if R4 <= t2
            CR = R3;
        end
        parent_vector = Parent_set(inii); %取出index种群的第j个个体
        Trial_vector = CrossOper(D,Trial_vector,parent_vector,CR);%做基因型的比较和替换
        
        %individual 类型转换
        if calObj
            addpro = {CR,F};
            Trial_vector = INDIVIDUAL(Trial_vector,addpro);
        end
    
        %Selection 选择操作 （必要的，决定子目标能不能达到）          
        parent_obj  = parent_vector.objs;
        Trial_obj  = Trial_vector.objs;
        
        k = 5;   %1029-10%1114-5
        na = 40;%种群个体少—100，种群个体多—70
        
        %个体替换
        if Trial_obj(obj) < parent_obj(obj) 
            %在提取的子种群个体集合中做替换
            Parent_set(inii) = Trial_vector; 
            %是否在输出的档案中做积累
            r1 = rand;
            if r1<0.5 %error
                [new_vector,novelty_threshold] = addArchivee(Archive{3},Trial_vector,novelty_threshold,k,subnum,obj,nnstruct);
                Archive{2} = [Archive{2},new_vector];
                Archive{3} = [Archive{3},new_vector];
            else %dist
                [new_vector,novelty_threshold] = addArchive(Archive{3},Trial_vector,novelty_threshold,k,obj);
                Archive{1} = [Archive{1},new_vector];
                Archive{3} = [Archive{3},new_vector];
            end
        end           
        
        %循环与输出 
         Parents{obj} = Parent_set; %把提取的子种群替换掉原来的子种群 

    end
end

%{
        %前a个只比较距离目标的大小
        if size(Archive,2) < a
            if Trial_obj(obj) < parent_obj(obj)
                Parent_set(inii) = Trial_vector; %在提取的子种群个体集合中做替换
                Archive = [Archive,Trial_vector];%在输出的档案中做积累
            end
        %第a+1个计算创新度
        elseif size(Archive,2) == a
            novelty_threshold = disKNN3(Trial_vector.obj,Archive,obj,k);
            %%%%%%加速就不要这里的if
            %if Trial_obj(index) < parent_obj(index)
                Parent_set(inii) = Trial_vector; %在提取的子种群个体集合中做替换
                Archive = [Archive,Trial_vector];%在输出的档案中做积累
            %end
        %超过a个就缩减剔除
        else
            %满足创新度——计算目标大小
            if disKNN3(Trial_vector.obj,Archive,obj,k) > novelty_threshold
                if Trial_obj(obj) < parent_obj(obj)
                    Parent_set(inii) = Trial_vector; %在提取的子种群个体集合中做替换
                    Archive = [Archive,Trial_vector];%在输出的档案中做积累
                end
                novelty_threshold = novelty_threshold*1.1; % 参数不知道要不要改
            %不满足创新度——缩减剔除
            else
                novelty_threshold = novelty_threshold*0.9999; % 参数不知道要不要改
                for m = 1:size(Archive,2)
                    temp(m,:) = Archive(m).obj;
                end
                middle = mean(temp(:,obj));%1,2
                tempsic = (temp(:,obj)<middle);%1,2
                temprand = randperm(size(Archive,2),20);
                tempsic(temprand) = 1;
                Archive = Archive(tempsic);
                clear temp
                clear tempsic
                clear temprand                
            end
        end
%}
