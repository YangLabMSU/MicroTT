clear ; clc ; close ;

% load data
% load('Stretch Experiment Data Fit - v2.mat') ;
% load('All Stretch Experiments Table.mat') ;
% load('Average Stretch Table.mat') ;
% load('Average Stretch Experiments.mat') ; 
% 
% load('Stretch Experiment Data Fit - Sub 6-14.mat') ;
% load('All Stretch Experiments Table - Sub 6-14.mat') ;
% load('Average Stretch Table - Sub 6-14.mat') ;
% load('Average Stretch Experiments - Sub 6-14.mat') ; 

load('Stretch Experiment Data Fit - IPS Fatigue.mat') ; 
load('All IPS Fatigue Stretch Experiments Table.mat') ; 
load('Average Stretch IP-S Fatigue Experiment.mat') ; 
load('Average Stretch IP-S Fatigue Table.mat') ; 


AllExpTable = AllStretchExperimentTable(2:end,:) ;
AvgTable = AverageTable(2:end,:) ;
Dates = [ "10/18/2023" "11/1/2023" "11/8/2023"] ; 


for n = 1:size(AvgTable,1)

    ModandLam = [] ;
    YieldData = [] ; 

    Date = Dates(n) ;
    matching_rows = ( AllExpTable(:,3) == Date ) ;
    [MRidx, ~] = find(matching_rows == 1) ;

    for nn = 1:size(MRidx,1) 
        ModandLam(nn,:) = StretchExperimentData{MRidx(nn), 5} ;
        YieldData(nn,:) = StretchExperimentData{MRidx(nn), 7} ;
    end

    AveragedStretchExps{n,7} = ModandLam ; 
    AveragedStretchExps{n,8} = YieldData ; 

end

%save("Average Stretch IP-S Fatigue Experiment.mat", "AveragedStretchExps") ; 

%StretchExperimentData = [ StretchExperimentData AvgExpData ] ;

%PlotFig = figure('Units','normalized', 'Position', [0.32,0.28,0.56,0.53] ) ;

% for n = 1:size(AvgExpData,1)
% 
%     Data = AvgExpData{n} ;
%     Parameters = AvgTable(n,:) ;
% 
%     if size(Data, 1) > 1
%         FitParameterPlotting(Data, Parameters) ;
% 
%         parts = split(Parameters(2), '/');  % Split the string by hyphens
%         month = parts{1};
%         day = parts{2};
%         year = parts{3};  % Assuming the year is in the 21st century
%         SubSave = month + "-" + day + "-" + year;
% 
%         % Save in Folder, and Save in a All Experiment Folder
%         figname = sprintf("%s_%s_TableIdx %d", Parameters(1), SubSave, n) ;
% 
%         % Define the directory where the figure will be saved
%         newFolder = 'Fitting Parameter Averaging - v2' ;
% 
%         % Check if the folder exists, if not, create it
%         if ~exist(newFolder, 'dir')
%             mkdir(newFolder);
%         end
% 
%         fileName = figname+'.tiff';
% 
%         % Local Path
%         path = cd ;
%         fullFilePath = fullfile(path, newFolder, fileName);
% 
%         % Save the figure as a JPEG file
%         saveas(PlotFig, fullFilePath, 'tiff');
% 
%         pause(0.1) ;
%     end
% 
% 
% 
% 
% end


