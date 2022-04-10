% folder = fullfile('G:\cocoRBF\SAN0611');
% 数据都在这个下面 BiGE KnEA NSGAIII2 MOEAD2 SAN0118/Crious II=Curious I SAN1127=SAN 
% folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate\SAN0611');
% SAN0611=curious II
%% Drawpicture
%%%%% evaluate from stored data %%%%
dizhi = {'\SAN0611','\NSGAIII2','\MOEAD2','\BiGE','\KnEA'};%,'\CuriousII','\SAN1127'
folder = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate1125');
fold = fullfile('G:\cocoRBF\SANNN0228_latest\dataevaluate1125\SAN1127');
addpath(fold);
addpath('G:\cocoRBF\SANNN0228_latest\Metrics')
addpath('G:\cocoRBF\SANNN0228_latest\WFG')
addpath('G:\cocoRBF\SANNN0228_latest')
archive = cell(5,8);
M = [2,3,5,10];
for r = 1:2  %n是要读入的文件的个数
    for name = 1:5
    for i = 1:1
    for j = 1:8 
        DD = 24;
        if (j==2)||(j==3)
            if M(i)==2 || M(i)==10
                DD = 25;
            end
        end
        temp = load([folder dizhi{name} dizhi{name} '_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']);
        [folder dizhi{name} '1_WFG' num2str(j) '_M' num2str(M(i)) '_D' num2str(DD) '_' num2str(r) '.mat']
        archive{name,j} = [archive{name,j}, temp.Population];
    end
    end
    end
end
for name = 1:5
    for j = 1:8 
        %figure(1)
        Draw(archive{name,j}.objs);
        load(['G:\cocoRBF\SANNN0228_latest\Data\SAN1127\WFG' num2str(j) '_obj_M' num2str(M(i)) '.mat']);
        plot(obj.PF(:,1),obj.PF(:,2),'r','LineWidth',2)
        figname = ['E:\figs\' num2str(name) '-' num2str(j) 'p.jpg' ];
        saveas(gcf,figname)
        close
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
for r = 1:9  %n是要读入的文件的个数
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