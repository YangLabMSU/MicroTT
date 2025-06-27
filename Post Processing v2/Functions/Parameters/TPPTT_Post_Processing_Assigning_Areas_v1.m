clear ; clc ; close ; 

% Data Processing -- Assign Fiber Areas to Each Experiment! 

% Load In Folder Containing All Experiments
SelectedFolder = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed" ; 
AllExpFolders = dir(SelectedFolder) ;

i = 0 ;
for n = 1:1:size(AllExpFolders,1)

    if AllExpFolders(n).isdir == 1 && AllExpFolders(n).name ~= "." && AllExpFolders(n).name ~= ".."
        i = i + 1 ;
        ExperimentFolders(i,:) = AllExpFolders(n,:) ;
    end

end

load('SEM Measurement Data.mat') ; 
SEMData = SEM_Measurement_Data(2:end, :) ; 

for nn = 1:size(ExperimentFolders,1)

expfolder = fullfile(ExperimentFolders(nn).folder, ExperimentFolders(nn).name);

% Load Data Set -- Select or Input the Folder
filename = "Video and Parameters.mat" ;
DataDirectory = TPPTT_DirectoryGenerator(expfolder, filename) ;
%DataDirectory = LoadRawDataExperimentDirectory() ; 

% For Each Data Folder with Raw Data -- Load the Data
for n = 1:2 %1:size(DataDirectory,1) 

    Video = [] ; 
    Parameters = [] ; 

    % DataFilePath = fullfile(DataDirectory(n,1),"Raw Data.mat") ; load(DataFilePath) ;
    ParameterFilePath = fullfile(DataDirectory(n,1),"Video and Parameters.mat") ; load(ParameterFilePath) ; 
     
    % Find Parameter Match for SEM Area Determination
    % 1) "Material", 2) "Laser Power (%max, max = 50 mW)", 3) "Write Speed (mm/s)"...
    % 4) "Fiber Width (um)", 5) "Fiber Height (um)", 6) "Slice Distance (um)", ...
    % 7) "Hatch Distance (um)", 8) "Hatch Style" 

    if Parameters.Material == "IP-VISIO" 

        Parameters.Material = "IP-Visio" ; 
    
    elseif Parameters.Material == "IP-DIP"

        Parameters.Material = "IP-Dip" ; 

    end

    ParameterVector = [ Parameters.Material, Parameters.WritingPower, Parameters.WritingSpeed,...
        Parameters.FiberWidth, Parameters.FiberHeight, Parameters.SliceDistance,...
        Parameters.HatchDistance, Parameters.HatchStyle ] ; 

    % Match Data
    RowMatch = find(all(SEMData(:,1:8) == ParameterVector, 2)) ;

    if ~isempty(RowMatch) 

        Parameters.FiberArea = SEMData(RowMatch, 10) ; 
        disp( [ "SEM Area: " Parameters.FiberArea ] ) ; 

    else 

        disp([ "Error: " Parameters.FolderName ])

        if Parameters.Material == "IP-Visio" && Parameters.WritingPower == "100"

            Parameters.WritingSpeed = 15 ; 

            ParameterVector = [ Parameters.Material, Parameters.WritingPower, Parameters.WritingSpeed,...
                Parameters.FiberWidth, Parameters.FiberHeight, Parameters.SliceDistance,...
                Parameters.HatchDistance, Parameters.HatchStyle ] ;

                % Match Data
            RowMatch = find(all(SEMData(:,1:8) == ParameterVector, 2)) ;
            Parameters.FiberArea = SEMData(RowMatch, 10) ;
            disp( [ "Found the SEM Area: " Parameters.FiberArea ] ) ;

        end

    end

    % VideoSavePath = fullfile(DataDirectory(n,1), "Video") ; 
    % ParameterSavePath = fullfile(DataDirectory(n,1), "Parameters") ; 
    % save(ParameterSavePath, "Parameters") ; 
    % save(VideoSavePath, "Video") ; 

end

end