clear ; clc ; close ;

% load data
% load('Stretch Experiment Data Fit - v2.mat') ;
% load('All Stretch Experiments Table.mat') ;
% load('Average Stretch Table.mat') ;
% load('Average Stretch Experiments.mat') ; 

load('Stretch Experiment Data Fit - Sub 6-14.mat') ;
load('All Stretch Experiments Table - Sub 6-14.mat') ;
load('Average Stretch Table - Sub 6-14.mat') ;
load('Average Stretch Experiments - Sub 6-14.mat') ; 

AllExpTable = AllStretchExperimentTable(2:end,:) ;
AvgTable = AverageTable(2:end,:) ;

for n = 1:size(AvgTable,1)

    Experiments = strsplit(AvgTable(n,4), ',') ;
    Experiments = double(Experiments) ;

    Material = AvgTable(n,1) ;
    Substrate = AvgTable(n,2) ;

    Parameters = [] ;
    YieldData = [] ; 

    for nn = 1:size(Experiments,2)

        matching_rows2 = (AllExpTable(:,1) == Material & AllExpTable(:,2) == Substrate...
            & double(AllExpTable(:,5)) == Experiments(nn)) ;
        [MRidx, ~] = find(matching_rows2 == 1, 1, 'first') ;

        if ~isempty(StretchExperimentData{MRidx, 5})

           paramData = StretchExperimentData{MRidx, 5};
            if size(paramData, 2) == 3

                Parameters(nn, 1:3) = paramData;
                Parameters(nn, 4:5) = strings(1, 2);  % Fill the remaining with empty strings
                YieldData(nn,:) = StretchExperimentData{MRidx, 7} ; 

            elseif size(paramData, 2) == 5

                Parameters(nn, :) = paramData;
                YieldData(nn,:) = StretchExperimentData{MRidx, 7} ; 

            end

        else

            Parameters(nn, :) = strings(1, 5);  % Assume 5 columns, fill with empty strings
            YieldData(nn,:) = strings(1, 2); 

        end

    end

    AvgExpData{n,1} = Parameters ;
    AveragedStretchExps{n,12} = Parameters ; 
    AveragedStretchExps{n,13} = YieldData ; 

end

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


