clear ; clc ; close ; 

% Generate a Table of all Processed Data Available

AllDataFolderPath = "D:\TPP uTT IP-PDMS Analysis\Processed Data" ; 
AllDataFolders = dir(AllDataFolderPath) ;

i = 0 ;
for n = 1:1:size(AllDataFolders,1)
    if AllDataFolders(n).isdir == 1 && AllDataFolders(n).name ~= "." && AllDataFolders(n).name ~= ".."
        i = i + 1 ;
        ExperimentFolders(i,:) = AllDataFolders(n,:) ;
        Experiments(i,:) = string(ExperimentFolders(i).name) ; 
    end
end

Experiments = SortByDate(Experiments) ; 
% Experiments = sort(double(Experiments)) ; 
% Experiments = string(Experiments) ; 
Folder = ExperimentFolders(1).folder ;

TableExpHeader = [ "Material", "Substrate", "Test Date", "Test Condition", "Array Position", "Beam Thickness (um)", "Beam Stiffness (N/m)", ...
    "Writing Power (%max, 50 mW)", "Writing Speed (mm/s)", "Fiber Width (um)", "Fiber Height (um)", "Slice Distance (um)", "Hatch Distance", ...
    "Hatch Style", "SEM Fiber Area (um^2)", "Initial Measured Fiber Length (um)", "Experiment Displacement (um)", "Experiment Displacement Rate (um/s)", "Hold Duration (s)", "Experiment Cylces", "Recovery Observation time (s)", ...
    "Experiment Notes", "Total Frames", "Processed Frames", "Data Smoothing Factor", "Pixel to Micron Adjustment", "Data Path"] ; 

AllTableVectors = [] ; 
%%

for n = 1:size(Experiments,1)

    expfolder = fullfile(Folder, Experiments(n));
    filename = "Processed Data.mat" ;
    DataDirectory = TPPTT_DirectoryGenerator(expfolder, filename) ;

    for ExperimentNumber = 1:length(DataDirectory)

        ExperimentPath = DataDirectory(ExperimentNumber) ;
        ProcessedDataPath = fullfile(ExperimentPath,"Processed Data.mat") ;
        load(ProcessedDataPath) ;

        TableVector = [ProcessedData.Parameters.Material, ProcessedData.Parameters.Substrate, ...
            ProcessedData.Parameters.TestDate, ProcessedData.Parameters.Condition, ProcessedData.Parameters.ArrayPosition, ...
            ProcessedData.Parameters.BeamThickness, ProcessedData.Parameters.BeamStiffness, ProcessedData.Parameters.WritingPower, ...
            ProcessedData.Parameters.WritingSpeed,...
            ProcessedData.Parameters.FiberWidth, ProcessedData.Parameters.FiberHeight, ProcessedData.Parameters.SliceDistance, ...
            ProcessedData.Parameters.HatchDistance, ProcessedData.Parameters.HatchStyle, ProcessedData.Parameters.FiberArea, ...
            ProcessedData.FiberLength(1), ProcessedData.Parameters.DisplacementDistance, ...
            ProcessedData.Parameters.DisplacementRate, ProcessedData.Parameters.HoldDuration, ProcessedData.Parameters.Cycles, ...
            ProcessedData.Parameters.RecoveryDuration, ProcessedData.Parameters.Notes, ...
            ProcessedData.Parameters.TotalFrames, ProcessedData.Parameters.Frames2Save, ...
            ProcessedData.Parameters.SmoothFactor, ...
            ProcessedData.Parameters.P2MR_Adj, ProcessedDataPath ] ; 

        AllTableVectors = [ AllTableVectors ; TableVector ] ;

    end

end

AllExperimentTable = [ TableExpHeader ; AllTableVectors ] ; 

save("All IP-PDMS Data Table", "AllExperimentTable") ; 
