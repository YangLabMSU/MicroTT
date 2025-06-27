clear ; clc ; close ;

% Assigning Parameters
%ExpFolderPath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23"  ;
ExpFolderPath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ; 

% Define the excel file name
ExcelName = "TPPTT Experiments - Sub_9-5-23 - TD_10-18-23" ;
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

    % % Assign Fiber Area
    if Parameters.Substrate == "10/27/2023" 
        if Parameters.WritingPower == "45"
            Parameters.FiberArea = 11.6058 ; 
        elseif Parameters.WritingPower == "75" 
            Parameters.FiberArea = 19.706 ; 
        end
    elseif Parameters.Substrate == "9/5/2023"
            Parameters.FiberArea = 13.06 ; 
    end

    % Save All Parameters and Video
    VGD = fullfile(ExperimentFolders(n,1),"Video and Parameters") ;    %Save File for Vid and Grid Data (VGD)
    ParameterSave = fullfile(ExperimentFolders(n,1),"Parameters") ;
    VideoSave = fullfile(ExperimentFolders(n,1),"Video") ;

    save(VGD,"Video","Parameters") ;
    save(ParameterSave,"Parameters") ;
    save(VideoSave,"Video") ;

end


