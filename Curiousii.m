function SAN0611(Global)
% <algorithm> <G>
%------------------------------- Reference --------------------------------
%  Vargas D V, Murata J, Takano H, et al. General subpopulation framework 
%  and taming the conflict inside populations[J]. Evolutionary computation, 
%  2015, 23(1): 1-36.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this plat0form or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Generate random population（initialization）
    Classical_sub = ones(1,Global.M)*3;
    Novety_sub = ones(1,2)*4;
    Smatric =[Classical_sub,Novety_sub]*Global.N;
    subnum = Global.M+2; % num of subpop
    Population = cell(subnum,1);
    C1 = {};
    for i = 1:subnum
        Population{i} =  Global.Initialization(Smatric(i));
        C1 = [C1 Population{i}];
    end
    %————————————————— surrogate model training stage————————————————%
    Error = [];
    %L = [dataset.decs,dataset.objs];
    nc = 10;
    [ W2,B2,Centers,Spreads ] = RBF(C1.decs,C1.objs,nc);
    TestNNOut = RBF_predictor(W2,B2,Centers,Spreads,C1.decs);
    error = sqrt(mean((C1.objs - TestNNOut).^2,1));%sum(abs(C1.objs - TestNNOut));
    Error = [Error; error];
    nnstruct = struct('W',W2,'B',B2,'Centers',Centers,'Spreads',Spreads);

    %——————————————————————parameter——————————————————————%
    Archive1 = [];Archive2 = [];Archive3 = [Archive1,Archive2];
    novelty_threshold = 0.1; 
    rc_nt = []; % record novelty threshold
    rc_num = []; % record Archive size in each round
    diff_nt = cell(subnum-1,1);% difference of novelty threshold
    Archive = {Archive1,Archive2,Archive3}; 
    clear Archive1 Archive2 Archive3
    while Global.NotTermination(Archive{3})
        %————————————————————the classical subpopulation————————————————————%
        for inii = 1:subnum-2
            if Global.evaluated <= sum(Smatric)*2
                para = {0.6,0.1};
                [Archive,novelty_threshold,Population] = SDEE0611(Population,...
                inii,Global.D,Archive,novelty_threshold,nnstruct,para);           
            else
                [Archive,novelty_threshold,Population] = SDEE0611(Population,...
                    inii,Global.D,Archive,novelty_threshold,nnstruct); 
            end
        end

        %————————————————————— the MONA subpopulation —————————————————————%
        if Global.evaluated <= sum(Smatric)*2
            para = {0.6,0.1};
            [Archive,novelty_threshold,Population] = SMONA0118(Population,Global.D,Archive,novelty_threshold,nnstruct,para); 
            [Archive,novelty_threshold,Population] = SMONE0118(Population,Global.D,Archive,novelty_threshold,nnstruct,para); %这里是改过的population{i}                        
        else
            [Archive,novelty_threshold,Population] = SMONA0118(Population,Global.D,Archive,novelty_threshold,nnstruct); 
            [Archive,novelty_threshold,Population] = SMONE0118(Population,Global.D,Archive,novelty_threshold,nnstruct); %这里是改过的population{i}                        
        end
        rc_nt = [rc_nt,novelty_threshold];
        rc_num = [rc_num;numel(Archive{1}), numel(Archive{2})];
    
       %————————————————————the surrogate model——————————————————————%
       %{
       if numel(Archive{3})< 100
            archive = [Archive{3},Population{1},Population{2}];
            %Case = 1;
       else 
           archive = Archive{3};
       end
       [ W2,B2,Centers,Spreads ] = RBFNov(archive.decs,archive.objs,nc);
        NovNNOut = RBF_predictor(W2,B2,Centers,Spreads,archive.decs);
        error = sqrt(mean((archive.objs - NovNNOut).^2,1));%sum(abs(Archive{3}.objs - NovNNOut));
        Error = [Error; error];
        nnstruct = struct('W',W2,'B',B2,'Centers',Centers,'Spreads',Spreads);
       %}
        if (Global.evaluation * 0.1) < Global.evaluated && Global.evaluated <(Global.evaluation * 0.1+140)
            figure(1)
            for i=1:3
                subplot(3,1,i)
                Draw(Archive{i}.objs)
            end
        end
            
        if (Global.evaluation * 0.3) < Global.evaluated && Global.evaluated <(Global.evaluation * 0.3+140)
            figure(2)
            for i=1:3
                subplot(3,1,i)
                Draw(Archive{i}.objs)
            end
        end
        
        if ((Global.evaluation * 0.9) < Global.evaluated && Global.evaluated <(Global.evaluation * 0.9+140))
            figure(3)
            for i=1:3
                subplot(3,1,i)
                Draw(Archive{i}.objs)
            end
        end
        
        if size(Archive{3},2) > 0 %Smatric(1)300
          %{
           % Non-dominated sorting
            [FrontNo,MaxFNo] = NDSort(Archive.objs,Archive.cons,Global.N);
            Next = FrontNo < MaxFNo;
            Archive = Archive(Next);
          %}
          %Archive = sorting(Archive,Global);
            continue
        end
    end
    %}
end   
    
function Archive = sorting(Archive,Global)
       % Non-dominated sorting
        [FrontNo,MaxFNo] = NDSort(Archive.objs,Archive.cons,Global.N);
        Next = FrontNo < MaxFNo;
        %Archive = Archive(Next);
        if MaxFNo ~=1
            Archive = Archive(Next);
        end
end
