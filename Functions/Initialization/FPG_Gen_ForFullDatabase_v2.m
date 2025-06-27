clear ; clc ; close ;

% Folder, Parameter, and Grid Generation -- for full database

% Load in Folder(s) All Experiemntal Folders
selectedFolder = uigetdir('Select a folder containing experiment folders and video files','');

% Check if the user canceled the operation
if selectedFolder == 0
    disp('Operation canceled by user.');
    return;
end

allfolders = dir(selectedFolder) ; 
i = 0 ; 
for n = 1:1:size(allfolders,1) 

    if allfolders(n).isdir == 1 && allfolders(n).name ~= "." && allfolders(n).name ~= ".."
        i = i + 1 ; 
        experimentfolders(i,:) = allfolders(n,:) ; 
    end

end

for n = 1:1:size(experimentfolders) 
experimentdates(n,1) = datetime(experimentfolders(n).date) ; 
end

[~,MaxIndex] = sort(experimentdates) ;
experimentdates = experimentdates(MaxIndex); 
experimentfolders = experimentfolders(MaxIndex) ;

time1 = tic ; 

for n = 1:1:size(experimentfolders) 

expfolder = fullfile(experimentfolders(n).folder, experimentfolders(n).name); 

% Find All Videos in the Folder, List all files in the selected folder
files = dir(fullfile(expfolder, '*.mp4'));

% Check if there are any mp4 files in the folder
if isempty(files)
    disp('No mp4 files found in the selected folder.');
end

% For each video file, generate a refernce number parameter to associate with video and table
for i = 1:1:length(files)

    FileName = files(i).name ;
    VidNum = strsplit(FileName,'_') ;

    if size(VidNum,2) > 1

        VidNum = strsplit(VidNum{2},'.') ;
        files(i).VideoNumber = double(string(VidNum{1})) ;

    else

        files(i).VideoNumber(i) = 0 ;

    end

end

% Use the Excel Sheet to Important Experiment Details, Search for an Excel file in the selected folder
excelFiles = dir(fullfile(expfolder, '*.xls*'));

% Check if an Excel file was found
if isempty(excelFiles)
    disp('No Excel file found in the selected folder.');
else

    % Evaluate the Excel Files to Find the Experiment Details File
    for i = 1:1:length(excelFiles)

        StringtoCheck = string(excelFiles(i).name) ;
        String = "TPPTT" ;
        Check(i) = contains(StringtoCheck, String) ;

    end

    % Choose the First File which Matches
    TPPTTExcelCheck = find(Check == 1, 1, 'First') ;

    % Define the excel file name
    excelFileName = fullfile(expfolder, excelFiles(TPPTTExcelCheck).name);

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

end

% Generate a video file path for each experiment
NumberExperiments = size(ExperimentDetails, 1) ;
ExperimentHeader(1,23) = "Video File Path: " ;
for n = 1:1:length(files)

    VidNum2Match = double(files(n).VideoNumber) ;
    VidNum2Find = double(ExperimentDetails(1:end,21)) ;
    Matching = find(VidNum2Find == VidNum2Match) ;
    ExperimentDetails(n,23) = fullfile(files(n).folder, files(n).name) ;

end

% Run each Video through the Auto-Grid Generation and save all parameters and exp details
currentFolder = pwd ;
currentFolder = strsplit(currentFolder,"\") ;
currentFolder = strjoin(currentFolder(:, 1:end-1),"\") ;
currentFolder = fullfile(currentFolder, "Templates", "Reference Grid.mat") ;
AutoTemplate = load(currentFolder) ;

for i = 1:1:NumberExperiments

    tic ; 

    Video = [] ;
    Parameters = [] ;
    Grids = [] ;

    % Define Individual Experimental Details
    ExpDets = ExperimentDetails(i,:) ;

    % Generate Parameters from Table
    Parameters = ParametersFromTable(ExpDets) ;

    % Read The Video
    Video = VideoReader(Parameters.VideoLoadPath) ;

    % Generate Parameters from Video
    Parameters.Folder = Video.Path ;
    Parameters.TotalFrames = Video.NumFrames ;
    Parameters.FrameRate = Video.FrameRate ;

    % Analysis Parameters
    FrameFraction = 0.33 ; % Percentage of Videos to Analyze
    Parameters.Frames2Save = round(Video.NumFrames * FrameFraction) ; % 1/3 ~ 10 Frames Per Second
    Parameters.ResolutionMultiplier = 4 ; % Resolution Multiplier (RM), Pixels(row) * RM
    Parameters.ReferenceFrameNumberList = ReferenceFrameNumberListGeneration(Parameters.TotalFrames, Parameters.Frames2Save) ;

    % Grid Generation
    Grids = Auto_Grid_and_Coordinate_Generation_v0(Video, Parameters, AutoTemplate) ; % Automated Grid Selection

    Grids = Auto_SetWBPixelRatio_v4(Grids, AutoTemplate) ; % Automated Black-White Image Conversion
    AutomatedGridCheck(Grids, Parameters) ;

    %Exporting and Saving Data (VD, FolderName, F2S, Grid Details)
    path = fullfile(Video.Path,Parameters.FolderName);
    mkdir(path);
    VGD = fullfile(path,'Video and Parameters') ;    %Save File for Vid and Grid Data (VGD)
    GridPath = fullfile(path,'Grid Data') ;
    save(VGD,'Video','Parameters');
    save(GridPath, 'Grids') ;

    toc ; 
end

end

disp("Done") ; 
time2 = toc ;
disp((time2-time1)) ; 
