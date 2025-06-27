clear ; clc ; close ;

% TPPTT Post Data Processing

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory() ;

% For Folder, Evaluate Data

for n = 1:size(DataDirectory,1)

    % Load in Specific Data
    DataPath = fullfile(DataDirectory(n,1), "Raw Data.mat") ;
    load(DataPath) ;
    ParamPath = fullfile(DataDirectory(n,1), "Parameters.mat") ;
    load(ParamPath) ;

    % Assign Stiffness based on Beam Size
    Parameters.BeamStiffness = BeamStiffnessAssign(Parameters.BeamThickness) ;

    % Assign Smoothing Factor
    Parameters.SmoothFactor = AssignSmoothFactor(Parameters.DisplacementRate) ; 

    % Generate Processed Data
    [SmoothProcessedData, ProcessedData] = TPPTTDataProcessor_NoAdjust(Data, Parameters) ;

    % Compare and Ensure that the Smoothed Data is accurate
    PlotFig = figure() ;
    PlotFig.Units = 'Normalized' ;
    PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
    TPPTT_Post_Process_Plotting_v3(ProcessedData, SmoothProcessedData) ;

    % Determine whether to save the data or not
    answer = questdlg('Export the Data?','Double Check','Yes','No','Yes');
    switch answer
        case 'Yes'
           
            ProcessedData = SmoothProcessedData ; 
            TPPTT_Post_Process_Plotting_v2(ProcessedData) ;

            SaveDataPath = fullfile(DataDirectory(n,1), "Processed Data.mat") ;    
            save(SaveDataPath, 'ProcessedData') ; 

            dirname = fullfile(string(Parameters.Folder), "Accepted Experiment Summaries" ) ;
            if ~exist(dirname, 'dir')
                mkdir(dirname)
            end

            figsave = fullfile(dirname, Parameters.FolderName);
            saveas(PlotFig,figsave,'tiff');

            close ; 

        case 'No'

            dirname = fullfile(string(Parameters.Parameters.Folder), "Rejected Experiment Summaries" ) ;
            if ~exist(dirname, 'dir')
                mkdir(dirname)
            end
            figsave = fullfile(dirname, Parameters.FolderName);
            saveas(PlotFig,figsave,'tiff');

            close ; 

    end


end