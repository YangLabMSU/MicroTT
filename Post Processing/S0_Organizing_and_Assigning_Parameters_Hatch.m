clear ; clc ; close ;

% Assigning Parameters

ExpFolderPath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Data Additions - v3 - Analyzed\Substrate 6-5-24_TD 6-27-24" ;
experiment = "1" ;
VidandPar = "Video and Parameters.mat" ;
loadpath = fullfile(ExpFolderPath,experiment,VidandPar) ;
load(loadpath);

% Load SEM Fiber Areas
SEMAreaPath = "K:\Yang Research\Two-Photon Polymerization\SEM\7-8-24\IP-S - 6-05-24\Average Area.mat" ;
load(SEMAreaPath) ;

% Define the excel file name
ExcelName = "TPPTT Experiments - Substrate_6-5-24 - TD_6-27-24.xlsx" ;
excelFileName = fullfile(ExpFolderPath, ExcelName);

% Read data from the Excel file
try
    [ ~, ~, alldata ] = xlsread(excelFileName);
    % Convert cell array to string array
    alldata = string(alldata);
    % Experiment Details
    ExperimentHeader = alldata(13, 1:22) ;
    ExperimentDetails = alldata(14:end, 1:22) ;
catch
    disp('Error reading the Excel file. Make sure it is a valid Excel file.');
end


% Generate Folder Path's for Experiment Folder
ExpFolder = dir(ExpFolderPath) ;
i = 1 ;
for n = 1:size(ExpFolder,1)
    Folder = ExpFolder(n,:) ;
    if  Folder.isdir == 1 && Folder.name ~= "." && Folder.name ~= ".." && ~isnan(double(string(Folder.name)))
        ExperimentFolders(i,1) = string(fullfile(Folder.folder, Folder.name)) ;
        ExperimentFolders(i,2) = string(Folder.name) ;
        i = i + 1 ;
    end
end

% Assign Parameters
for n = 1:size(ExperimentFolders,1)

    % Get the Video Number
    VideoNum = ExperimentFolders(n,2) ;

    % Match it to the Experiment Details
    DetailIdx = find(VideoNum == ExperimentDetails(:,21)) ;

    % Define Individual Experimental Details
    ExpDets = ExperimentDetails(DetailIdx,:) ;

    % Load Parameters
    VidandPar = "Video and Parameters.mat" ;
    loadpath = fullfile(ExperimentFolders(n,1),VidandPar) ;
    load(loadpath);

    % Generate Parameters from Table
    Parameters = S0_Wonky_Parameter_Update(Parameters, ExpDets) ;

    % Assign Fiber Area
    ArrayColumn = ExpDets(1,6) ;
    SEMIdx = find(ArrayColumn == SEMAreaAvg(:,1)) ;
    Parameters.FiberArea = SEMAreaAvg(SEMIdx,2) ;

    % Save All Parameters and Video
    VGD = fullfile(ExperimentFolders(n,1),"Video and Parameters") ;    %Save File for Vid and Grid Data (VGD)
    ParameterSave = fullfile(ExperimentFolders(n,1),"Parameters") ;
    VideoSave = fullfile(ExperimentFolders(n,1),"Video") ;

    save(VGD,"Video","Parameters") ;
    save(ParameterSave,"Parameters") ;
    save(VideoSave,"Video") ;

end


