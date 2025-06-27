clear ; clc ; close all ;

% Fitting Data

% Evaluating Data
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 4 %:size(DataDirectory)

    % Get Path
    loadpath = DataDirectory(n,1);

    % Load in Fit Data
    FitPath = fullfile(DataDirectory(n,1), "Fit Data.mat");
    load(FitPath);

    pks = FitData.Plate.Pktime ; 
    time = FitData.Plate.Pk ; 
    FitData.Plate.Pk = pks ; 
    FitData.Plate.Pktime = time ; 

    savepath = fullfile(loadpath, "Fit Data.mat") ;
    save(savepath, "FitData") ;

end
