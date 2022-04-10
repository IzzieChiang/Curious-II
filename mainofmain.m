addpath ('WFG')

main('-algorithm',@Curiousii,'-problem',@WFG1,'-N',10,'-M',3,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',30);

%% 1220
addpath ('WFG')
problemname = {@WFG1 @WFG2 @WFG3 @WFG4 @WFG5 @WFG6 @WFG7 @WFG8};%@WFG1 @WFG2 @WFG3 @WFG4 
for n=2:2  %n是要读入的文件的个数
    for r =8:8
    % SAN1127
    %main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',2,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',3,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',5,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',10,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',15,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    % san0118
    %main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',2,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',3,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',5,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',10,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',15,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    % san0301
    %main('-algorithm',@SAN0301,'-problem',problemname{n},'-N',10,'-M',2,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0301,'-problem',problemname{n},'-N',10,'-M',3,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0301,'-problem',problemname{n},'-N',10,'-M',5,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0301,'-problem',problemname{n},'-N',10,'-M',10,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    end
end
%%
addpath ('WFG')
problemname = {@WFG1 @WFG2 @WFG3 @WFG4 @WFG5 @WFG6 @WFG7 @WFG8};%@WFG1 @WFG2 @WFG3 @WFG4 
for n=5:8  %n是要读入的文件的个数
    for r =1:1
    % SAN1127
    %main('-algorithm',@SAN112702,'-problem',problemname{n},'-N',10,'-M',3,'-D',24,'-evaluation',325000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN112702,'-problem',problemname{n},'-N',10,'-M',5,'-D',24,'-evaluation',475000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN112702,'-problem',problemname{n},'-N',10,'-M',10,'-D',24,'-evaluation',850000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN112702,'-problem',problemname{n},'-N',10,'-M',15,'-D',24,'-evaluation',1225000,'-mode',1,'-save',5,'-run',r);
    % san1214
    main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',2,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',3,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',5,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    main('-algorithm',@SAN1127,'-problem',problemname{n},'-N',10,'-M',10,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    %main('-algorithm',@SAN0118,'-problem',problemname{n},'-N',10,'-M',15,'-D',24,'-evaluation',250000,'-mode',1,'-save',5,'-run',r);
    end
end


%% test for run
addpath('G:\cocoRBF\SANNN0228\Metrics')
addpath('G:\cocoRBF\SANNN0228\WFG')
filepath='Data\SAN0118';%文件夹的路径
result = {};
metric = {};
Score = cell(1,2);
load('Data\SAN1127\obj_M5.mat');
for r=8:30  %n是要读入的文件的个数
    temp = load([filepath '\SAN0118_WFG8_M5_D24_' num2str(r) '.mat']);
    temp2 = temp.result{end,end};
    result = [result,temp2];
    %copy from Global.
    if isempty(temp2)==0
        %-------------------% final population--------------------%
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        
        %-----------------% Calculate the metric values-----------%
        Score{1} = [Score{1} HV(Population.objs,obj.PF)];
        Score{2} = [Score{2} IGD(Population.objs,obj.PF)];
    end
end
Hv = mean(Score{1});Igd = mean(Score{2});

%%
folder = fullfile('G:\cocoRBF\SANNN0228\data1\CuriousII');
addpath(folder);
addpath('G:\cocoRBF\SANNN0228\Metrics')
addpath('G:\cocoRBF\SANNN0228\WFG')
filepath='Data\SAN0118';%文件夹的路径
result = {};
metric = {};
Score = cell(1,2);
load('Data\SAN1127\obj_M5.mat');
for r = 8:30  %n是要读入的文件的个数
    for j=1:8
        temp = load([filepath '\SAN0118_WFG' num2str(j) '_M5_D24_' num2str(r) '.mat']);
        temp2 = temp.result{end,end};
        % 修改的部分
        % final population
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        metric.HV  = HV(Population.objs,obj.PF);
        metric.IGD  = IGD(Population.objs,obj.PF);
        metric.GD  = GD(Population.objs,obj.PF);
        save(fullfile(folder,['\SAN0118_WFG' num2str(j) '_M5_D24_' num2str(r) '.mat']),'Population','NonDominated','metric');
    end
end
%%
folder = fullfile('G:\cocoRBF\SANNN0228\data1\CuriousII');
addpath(folder);
addpath('G:\cocoRBF\SANNN0228\Metrics')
addpath('G:\cocoRBF\SANNN0228\WFG')
filepath='Data\SAN0118';%文件夹的路径
result = {};
metric = {};
Score = cell(1,2);
load('Data\SAN1127\obj_M10.mat');
for r = 1:30  %n是要读入的文件的个数
    for j=1:8
        DD = 24;
        if (j==2)||(j==3)
            DD = 25;
        end
        temp = load([filepath '\SAN0118_WFG' num2str(j) '_M10_D' num2str(DD) '_' num2str(r) '.mat']);
        temp2 = temp.result{end,end};
        % 修改的部分
        % final population
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        metric.HV  = HV(Population.objs,obj.PF);
        metric.IGD  = IGD(Population.objs,obj.PF);
        metric.GD  = GD(Population.objs,obj.PF);
        save(fullfile(folder,['\SAN0118_WFG' num2str(j) '_M10_D' num2str(DD) '_' num2str(r) '.mat']),'Population','NonDominated','metric');
    end
end
%%
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\CuriousII');
addpath(folder);
addpath('G:\cocoRBF\SANNN0228_latest\Metrics')
addpath('G:\cocoRBF\SANNN0228_latest\WFG')
filepath='Data\SAN0118';%文件夹的路径
result = {};
metric = {};
Score = cell(1,2);
load('Data\SAN1127\obj_M3.mat');
for r = 9:9  %n是要读入的文件的个数
    for j=3:8
        DD = 24;
        if (j==2)||(j==3)
            DD = 24;
        end
        temp = load([filepath '\SAN0118_WFG' num2str(j) '_M3_D' num2str(DD) '_' num2str(r) '.mat']);
        temp2 = temp.result{end,end};
        % 修改的部分
        % final population
        Feasible     = find(all(temp2.cons<=0,2));
        NonDominated = NDSort(temp2(Feasible).objs,1) == 1;
        Population   = temp2(Feasible(NonDominated));
        metric.HV  = HV(Population.objs,obj.PF);
        metric.IGD  = IGD(Population.objs,obj.PF);
        metric.GD  = GD(Population.objs,obj.PF);
        save(fullfile(folder,['\SAN0118_WFG' num2str(j) '_M3_D' num2str(DD) '_' num2str(r) '.mat']),'Population','NonDominated','metric');
    end
end