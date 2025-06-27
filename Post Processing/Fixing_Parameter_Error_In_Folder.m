clear ; clc ; close all ; 

% Fixing a parameter error 

% Load Proper Directory
DataDirectory = LoadRawDataExperimentDirectory() ; 

for n = 1:length(DataDirectory) 

    path = DataDirectory(n) ; 
    params = fullfile(path, "Parameters.mat") ; 
    load(params) ; 
    Parameters.TestDate = "11/8/2023" ; 
    save(params, "Parameters") ; 

end