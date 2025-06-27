clear ; clc ; close ; 

% path = "12-07-23_TD 1-29-24" ; 

% Load In Folder Containing All Experiments
DataDirectory = LoadRawDataExperimentDirectory() ;

for n = 1:size(DataDirectory,1) 

    Video = [] ; 
    Parameters = [] ; 

    % DataFilePath = fullfile(DataDirectory(n,1),"Raw Data.mat") ; load(DataFilePath) ;
    ParameterFilePath = fullfile(DataDirectory(n,1),"Video and Parameters.mat") ; 
    load(ParameterFilePath) ; 
    
    Parameters.BeamThickness = 20 ; 

    %VideoSavePath = fullfile(DataDirectory(n,1), "Video") ; 
    ParameterSavePath = fullfile(DataDirectory(n,1), "Parameters") ; 
    save(ParameterSavePath, "Parameters") ; 
    save(ParameterFilePath, "Parameters", "Video") ; 

    %save(VideoSavePath, "Video") ; 

end