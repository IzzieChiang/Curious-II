function Trial_vector = mutationOper(Parents,F,subnum)
%Parents所有子种群，含所有个体
%F 超参数
%subnum 子种群数量
    for i =1:3 %因为只能选3个个体出来
        randSnum(i) = randperm(subnum,1); %取出任意一个子种群
        popnum = size(Parents{randSnum(i)},2); %这个子种群的个体数
        randPnum(i) =  randperm(popnum,1); %取出任意一个个体
        tempsub = Parents{randSnum(i)}; %提取子种群
        Parent(i,:) = tempsub(randPnum(i)).dec; %提取个体集合
    end    
    Trial_vector = Parent(1,:) + F*(Parent(2,:)-Parent(3,:));        
end