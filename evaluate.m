% folder = fullfile('G:\cocoRBF\SAN0611');
% 数据都在这个下面 BiGE KnEA NSGAIII2 MOEAD2 SAN0118/Crious II=Curious I SAN1127=SAN 
% folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\SAN0611');
% SAN0611=curious II
%% 1125以前
%%%% evaluate from stored data %%%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate1125\SAN0611');
addpath(folder);
addpath('G:\cocoRBF\SANNN0228_latest\Metrics')
addpath('G:\cocoRBF\SANNN0228_latest\WFG')
filepath='G:\cocoRBF\san0611\Data\SAN0611';%文件夹的路径
result = {};
metric = {};
Score = cell(1,2);
M = [2,3,5,10];

for r = 1:9  % run times
    for i = 1:4
    for j = 2:2
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        load(['G:\cocoRBF\SANNN0228_latest\Data\SAN1127\WFG1_obj_M' num2str(M(i)) '.mat']);
        temp = load([filepath '\SAN0611_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [filepath '\SAN0611_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        temp2 = temp.result{end,end};
        % 修改的部分
        % final population
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        metric.HV  = HV(Population.objs,obj.PF);
        metric.IGD  = IGD(Population.objs,obj.PF);
        metric.GD  = GD(Population.objs,obj.PF);
        save(fullfile(folder,['\SAN0611_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']),'Population','NonDominated','metric');
    end
    end
end

%% Curious II
%%%%% evaluate from stored data %%%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\SAN0611');
addpath(folder);
HVScore = zeros(8,4,9);
IGDScore = zeros(8,4,9);
GDScore = zeros(8,4,9);
M = [2,3,5,10];
for r = 1:9  %n是要读入的文件的个数
    for i = 1:4
    for j = 1:8
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        temp = load([folder '\SAN0611_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [folder '\SAN0611_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        HVScore(j,i,r) = temp.metric.HV;
        IGDScore(j,i,r) = temp.metric.IGD;
        GDScore(j,i,r) = temp.metric.GD;
    end
    end
end

%% others
%%%% evaluate from stored data %%%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\BiGE');
addpath(folder);
HVScore = zeros(8,4,9);
IGDScore = zeros(8,4,9);
GDScore = zeros(8,4,9);
M = [2,3,5,10];
for r = 1:30  %n是要读入的文件的个数
    for i = 1:4
    for j = 1:8
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        temp = load([folder '\BiGE_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [folder '\BiGE_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        HVScore(j,i,r) = temp.metric.HV;
        IGDScore(j,i,r) = temp.metric.IGD;
        GDScore(j,i,r) = temp.metric.GD;
    end
    end
end
%% 
GDavgScore = zeros(8,4,4);
GDavgScore(:,:,1) = mean(GDScore,3) ;
GDavgScore(:,:,2) = max(GDScore,[],3) ;
GDavgScore(:,:,3) = min(GDScore,[],3) ;
GDavgScore(:,:,4) = std(GDScore,[],3) ;

HVavgScore = zeros(8,4,4);
HVavgScore(:,:,1) = mean(HVScore,3) ;
HVavgScore(:,:,2) = max(HVScore,[],3) ;
HVavgScore(:,:,3) = min(HVScore,[],3) ;
HVavgScore(:,:,4) = std(HVScore,[],3) ;

IGDavgScore = zeros(8,4,4);
IGDavgScore(:,:,1) = mean(IGDScore,3) ;
IGDavgScore(:,:,2) = max(IGDScore,[],3) ;
IGDavgScore(:,:,3) = min(IGDScore,[],3) ;
IGDavgScore(:,:,4) = std(IGDScore,[],3) ;
%% Curious I
% 1125以后
%%%% evaluate from stored data %%%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate1125\SAN1127');
addpath(folder);
addpath('G:\cocoRBF\SANNN0228_latest\Metrics')
addpath('G:\cocoRBF\SANNN0228_latest\WFG')
addpath('G:\cocoRBF\SANNN0228_latest')
filepath='G:\cocoRBF\SAN112702';%文件夹的路径
%'G:\cocoRBF\SAN112702';
result = {};
metric = {};
Score = cell(1,2);
M = [2,3,5,10];

for r = 16:30  % run times
    for i = 2:4
    for j = 1:8
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        load(['G:\cocoRBF\SANNN0228_latest\Data\SAN1127\WFG' num2str(j) '_obj_M' num2str(M(i)) '.mat']);
        temp = load([filepath '\SAN112702_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [filepath '\SAN112702_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        temp2 = temp.result{end,end};
        % 修改的部分
        % final population
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        metric.HV  = HV(Population.objs,obj.PF);
        metric.IGD  = IGD(Population.objs,obj.PF);
        metric.GD  = GD(Population.objs,obj.PF);
        save(fullfile(folder,['\SAN1127_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']),'Population','NonDominated','metric');
    end
    end
end
%%
%%% evaluate from stored data %%%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate1125\SAN1127');
%folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\SAN0611');
addpath(folder);
HVScore = zeros(8,4,9);
IGDScore = zeros(8,4,9);
GDScore = zeros(8,4,9);
M = [2,3,5,10];
for r = 1:30  %n是要读入的文件的个数
    for i = 1:4
    for j = 1:8
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        temp = load([folder '\SAN1127_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [folder '\SAN1127_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        HVScore(j,i,r) = temp.metric.HV;
        IGDScore(j,i,r) = temp.metric.IGD;
        GDScore(j,i,r) = temp.metric.GD;
    end
    end
end