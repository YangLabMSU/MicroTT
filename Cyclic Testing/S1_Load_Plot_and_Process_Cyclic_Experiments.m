clear ; clc ; close ;
% Load and Plot, and Organize Cyclic Testing Experiments

folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ; 
% data1folder = "Substrate 9-05-23_TD 10-18-23" ; 

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 1:size(DataDirectory, 1) 

    % Get Path
    loadpath = DataDirectory(n,1) ; 
    
    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Raw Data.mat") ;
    load(DataPath) ;
    ParamPath = fullfile(DataDirectory(n,1), "Parameters.mat") ;
    load(ParamPath) ;

    % Assign Stiffness based on Beam Size
    Parameters.BeamStiffness = BeamStiffnessAssign(Parameters.BeamThickness) ;

    % Assign Smoothing Factor
    Parameters.SmoothFactor = 5 ; 

    % Assign Smoothing Factor
    [ SmoothProcessedData, ProcessedData ] = TPPTTDataProcessor_CyclicExps(Data, Parameters) ; 

    % Compare and Ensure that the Smoothed Data is accurate
    TPPTT_Post_Process_Plotting_Cyclic_v1(ProcessedData, SmoothProcessedData) ;

        % Determine whether to save the data or not
    answer = questdlg('Export the Data?','Double Check','Yes','No','Yes');
    switch answer
        case 'Yes'
           
            ProcessedData = SmoothProcessedData ; 
            % TPPTT_Post_Process_Plotting_v2(ProcessedData) ;

            SaveDataPath = fullfile(DataDirectory(n,1), "Processed Data.mat") ;    
            save(SaveDataPath, 'ProcessedData') ; 

            % dirname = fullfile(string(Parameters.Folder), "Accepted Experiment Summaries" ) ;
            % if ~exist(dirname, 'dir')
            %     mkdir(dirname)
            % end
            % 
            % figsave = fullfile(dirname, Parameters.FolderName);
            % saveas(PlotFig,figsave,'tiff');

            close all ; 

        case 'No'

            % dirname = fullfile(string(Parameters.Parameters.Folder), "Rejected Experiment Summaries" ) ;
            % if ~exist(dirname, 'dir')
            %     mkdir(dirname)
            % end
            % figsave = fullfile(dirname, Parameters.FolderName);
            % saveas(PlotFig,figsave,'tiff');

            close all ; 

    end

end
