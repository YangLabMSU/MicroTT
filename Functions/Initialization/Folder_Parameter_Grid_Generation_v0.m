
% % Folder Generation
% 
% % Load in Folder Containing Videos
% selectedFolder = uigetdir('Select a folder containing mp4 files');
% 
% % Check if the user canceled the operation
% if selectedFolder == 0
%     disp('Operation canceled by user.');
%     return;
% end

selectedFolder = 'K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Data v2\Substrate 7-24-23_TD 8-9-23' ; 

% Find All Videos in the Folder, List all files in the selected folder
files = dir(fullfile(selectedFolder, '*.mp4'));

% Check if there are any mp4 files in the folder
if isempty(files)

    disp('No mp4 files found in the selected folder.'); 

end

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
excelFiles = dir(fullfile(selectedFolder, '*.xls*'));

% Check if an Excel file was found
if isempty(excelFiles)

    disp('No Excel file found in the selected folder.');

else

    for i = 1:1:length(excelFiles)
        
        StringtoCheck = string(excelFiles(i).name) ; 
        String = "TPPTT" ; 
        Check(i) = contains(StringtoCheck, String) ;

    end

    % Choose the First File which Matches
    Yep = find(Check == 1, 1, 'First') ;

    % Read the first Excel file found (you can modify this to read a specific file)
    excelFileName = fullfile(selectedFolder, excelFiles(Yep).name);

    % Read data from the Excel file
    try
        [ ~, ~, alldata ] = xlsread(excelFileName);

        % Convert cell array to string array
        stringArray = string(alldata);

        % Substrate and Experiment Parameters
        Sub_and_Exp_Params = stringArray(2:10, 1:2) ; 

        % Experiment Details
        ExpDets = stringArray(13:end, 1:22) ; 


    catch

        disp('Error reading the Excel file. Make sure it is a valid Excel file.');

    end

end

NumberExperiments = size(ExpDets, 1) ; 
ExpDets(1,9) = "Video File Path: " ; 

for n = 1:1:length(files)

VidNum2Match = double(files(n).VideoNumber) ; 
VidNum2Find = double(ExpDets(2:end,6)) ; 
Matching = find(VidNum2Find == VidNum2Match) ; 
ExpDets(Matching+1, 9) = fullfile(files(n).folder, files(n).name) ; 

end

% Run each Video through the Auto-Grid Generation and save all parameters
% and exp details
%currentFolder = pwd ; 
AutoTemplate = load('K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v11 - 4-18-24\Templates\Reference Grid.mat') ;

%%
for i = 2:1:NumberExperiments
Video = [] ; 
Parameters = [] ; 
Grids = [] ; 

% Naming Parameters
Parameters.VideoLoadPath = ExpDets(i,9) ;
Parameters.FolderName = ExpDets(i,6) ; 

Video = VideoReader(Parameters.VideoLoadPath) ; 

% Frames and Frames to Save
Parameters.Folder = Video.Path ; 
Parameters.TotalFrames = Video.NumFrames ; 
Parameters.FrameRate = Video.FrameRate ; 
Parameters.Frames2Save = round(Video.NumFrames / 3) ;

% Experimental Details/Parameters
% Batch Parameters
Parameters.SenseBeamThickness = Sub_and_Exp_Params(4,2) ; 
Parameters.Materials = Sub_and_Exp_Params(5,2) ; 
Parameters.TestDate = Sub_and_Exp_Params(2,2) ; 
Parameters.FabDate = Sub_and_Exp_Params(1,2) ; 
Parameters.SubstrateExperiments = Sub_and_Exp_Params(3,2) ;
Parameters.WritingSpeed = Sub_and_Exp_Params(7,2) ; 
Parameters.WritingPower = Sub_and_Exp_Params(8,2) ;
Parameters.FiberLength = 20 ; 
Parameters.FiberDimension = Sub_and_Exp_Params(6,2) ; 
Parameters.Condition = Sub_and_Exp_Params(9,2) ;

% Individual Parameters
Parameters.StructureArrayNumber = ExpDets(i, 1) ;  
Parameters.ExpDisplacement = ExpDets(i, 3) ; 
Parameters.ExpDisplacementRate = ExpDets(i, 2) ;  
Parameters.HoldDuration = ExpDets(i,4) ; 
Parameters.NumberofCycles = ExpDets(i,5) ; 
Parameters.RecoveryObservationDuration = ExpDets(i,7) ; 
Parameters.ExpNotes = ExpDets(i,8) ; 

%Action Outputs
Parameters.ResolutionMultiplier = 4 ; % Resolution Multiplier (RM), Pixels(row) * RM
Parameters.ReferenceFrameNumberList = ReferenceFrameNumberListGeneration(Parameters.TotalFrames, Parameters.Frames2Save) ;

Grids = Automated_Grid_and_Coordinate_Generation_v2(Parameters, AutoTemplate) ; % Automated Grid Selection
Grids = Automated_SetWBPixelRatio_v4(Grids, AutoTemplate) ; % Automated Black-White Image Conversion
AutomatedGridCheck(Grids, Parameters) ;

% %Exporting and Saving Data (VD, FolderName, F2S, Grid Details)
% path = fullfile(Video.Path,Parameters.FolderName);
% mkdir(path);
% VGD = fullfile(path,'Video and Parameters') ;    %Save File for Vid and Grid Data (VGD)
% GridPath = fullfile(path,'Grid Data') ;
% save(VGD,'Video','Parameters');
% save(GridPath, 'Grids') ;

end

