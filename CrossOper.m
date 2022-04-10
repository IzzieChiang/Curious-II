function Trial_vector = CrossOper(D,Trial_vector,parent_vector,CR)
% D——决策空间维度/基因个数
% Trial_vector——测试个体的基因向量
% parent_vector——父代个体
% CR 超参数
    rndi = randperm(D,1); %随机生成一个基因代码，使得至少一个基因变异
    parent_vector = parent_vector.dec;
    Site = rand(1,D) > CR;
    Site(rndi) = 0;
    Trial_vector(Site) = parent_vector(Site);
end