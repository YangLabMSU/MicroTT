% TPP Tensile Testing Script
clear; clc; close; 
% Load in Folder Containing 
selectedFolder = uigetdir('Select a folder Analyzed Experiment Folders');

% Check if the user canceled the operation
if selectedFolder == 0
    disp('Operation canceled by user.');
    return;
end
filename = "Grid Data.mat" ; 
[DataDirectory] = TPPTT_DirectoryGenerator(selectedFolder, filename) ; 
%

%x = [ 1 20 21 25 26 27 29 31 32 36 ] ;
%%
for Experiments = 1:1:length(DataDirectory) 
tic; 

Data = [] ; 
ROI_Top = [] ; 
ROI_Bottom = [] ; 
Grids = [] ; 
RawData = [] ; 
Parameters = [] ; 
Video = [] ; 

ExperimentDirectory = DataDirectory(Experiments) ;
load(fullfile(ExperimentDirectory,"Grid Data.mat")) ; load(fullfile(ExperimentDirectory,"Video and Parameters.mat")) ;

% Generate a Figure
DICfig = figure() ;
DICfig.Position = [ 83, 144, 1770, 813 ] ;
PixelRange.Vertical = 5 ;
PixelRange.Horizontal = 3 ;

% Frame Rate Multiplier
SecondsPerFrame = Video.Duration / Video.NumFrames ; % Duration of Video (s) / Total Video Frames

% Initial BW Images
TGBWI = Grids.TopStructure.InitialBW ; % Top Grid BW Initial
BGBWI = Grids.BottomStructure.InitialBW ; % Top Grid BW Initial

% Initial Grid Coordinates
ROI_Top{1,1} = Grids.TopStructure.Coordinates ;
ROI_Bottom{1,1} = Grids.BottomStructure.Coordinates ;

%FramesUpdatePlot = round(Parameters.Frames2Save / 100) ;
FramesUpdatePlot = 10 ;
FrameCount2UpdatePlot = 0 ;

%% Analyze Each Requested Frame
for FrameCount = 1:1:Parameters.Frames2Save

    % Obtain the Proper Frame Number from RFNL
    Frame = Parameters.ReferenceFrameNumberList(FrameCount) ;
    Data.VideoFrame(FrameCount,:) = [ FrameCount Frame Frame*SecondsPerFrame ] ;
    Data.Time(FrameCount) = Frame*SecondsPerFrame ;

    % Read Next Frame in Sequence and Enhance Resolution for Proper Dimension on Analysis
    NextFrame = read(Video, Frame) ;
    Rows = size(NextFrame,1) ;
    NextFrame_Enhanced = imresize(NextFrame, [ Rows*Parameters.ResolutionMultiplier , NaN ]) ;

    if FrameCount == 1

        LastFrame = NextFrame_Enhanced ;
        PixelCount = sum(imcomplement(Grids.Fiber.InitialBW), "all"); %Grids.Fiber.ContourIBPCount ; 
        Grids.Fiber.IBPCount = PixelCount ; 
        Grids.Fiber.nset = 0.5 ; 

    end

    %% Bulk Grid Matching
    % Top Grid
    Grids.TopStructure.IBPCount = sum(imcomplement(Grids.TopStructure.InitialBW), "all");
    Grids.TopStructure.nset = 0.5 ; 
    [ROI_Top{FrameCount+1,1}, TopData] = TPP_TensileTesting_Analysis_Grid_Matching_v2(PixelRange, NextFrame_Enhanced, TGBWI, LastFrame, ROI_Top{FrameCount,1}, Grids.TopStructure.IBPCount, Grids.TopStructure.nset) ;

    % Bottom Grid
    Grids.BottomStructure.IBPCount = sum(imcomplement(Grids.TopStructure.InitialBW), "all") ;
    Grids.BottomStructure.nset = 0.5 ;
    [ROI_Bottom{FrameCount+1,1}, BottomData] = TPP_TensileTesting_Analysis_Grid_Matching_v2(PixelRange, NextFrame_Enhanced, BGBWI, LastFrame, ROI_Bottom{FrameCount,1}, Grids.BottomStructure.IBPCount, Grids.BottomStructure.nset) ;

    % Fiber
    FiberData = TPP_TensileTesting_Fiber_Evaluation_v5( ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, Grids, NextFrame_Enhanced, PixelCount) ;

    if isempty(FiberData) == 1

        break

    end

    %% Fine Grid Analysis
    Pixels2Find = 4 ; 
    [TopAdjust, BottomAdjust] = TPP_TensileTesting_Edge_Adjustment_Filter_v2( Grids, ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, NextFrame_Enhanced, Pixels2Find) ;

    %% Data Organization
    if FrameCount == 1 
        TopAdjustInitial = TopAdjust ; 
        BottomAdjustInitial = BottomAdjust ; 
    end

    Data.TopStructure.DisplacementX(FrameCount) = TopData.DisplacementX ;
    Data.TopStructure.DisplacementY(FrameCount) = TopData.DisplacementY ;
    Data.TopStructure.NumberPixelDifference(FrameCount) = TopData.NumberPixelDifference ;
    Data.TopStructure.LastFrameNumberPixelDifference(FrameCount) = TopData.LastFrameNumberPixelDifference ;
    Data.TopStructure.EdgeLine(FrameCount) = TopAdjust + ROI_Top{FrameCount+1,1}(1,1) ; 
    Data.TopStructure.Adjustment(FrameCount) = TopAdjust - TopAdjustInitial ; 
    Data.TopStructure.DisplacementYAdjusted(FrameCount) = TopData.DisplacementY - Data.TopStructure.Adjustment(FrameCount) ;

    Data.BottomStructure.DisplacementX(FrameCount) = BottomData.DisplacementX ;
    Data.BottomStructure.DisplacementY(FrameCount) = BottomData.DisplacementY ;
    Data.BottomStructure.NumberPixelDifference(FrameCount) = BottomData.NumberPixelDifference ;
    Data.BottomStructure.LastFrameNumberPixelDifference(FrameCount) = BottomData.LastFrameNumberPixelDifference ;
    Data.BottomStructure.EdgeLine(FrameCount) = BottomAdjust + ROI_Bottom{FrameCount+1,1}(1,1) ; 
    Data.BottomStructure.Adjustment(FrameCount) = BottomAdjust - BottomAdjustInitial ;
    Data.BottomStructure.DisplacementYAdjusted(FrameCount) = BottomData.DisplacementY - Data.BottomStructure.Adjustment(FrameCount) ;

    if FrameCount == 1
        Data.TopStructure.SumDisplacementX(FrameCount) = Data.TopStructure.DisplacementX(FrameCount) ;
        Data.TopStructure.SumDisplacementY(FrameCount) = Data.TopStructure.DisplacementY(FrameCount) ; 
        Data.TopStructure.SumDisplacementYAdjusted(FrameCount) = Data.TopStructure.DisplacementYAdjusted(FrameCount) ;

        Data.BottomStructure.SumDisplacementX(FrameCount) = Data.BottomStructure.DisplacementX(FrameCount) ;
        Data.BottomStructure.SumDisplacementY(FrameCount) = Data.BottomStructure.DisplacementY(FrameCount);
        Data.BottomStructure.SumDisplacementYAdjusted(FrameCount) = Data.BottomStructure.DisplacementYAdjusted(FrameCount) ;
    else
        Data.TopStructure.SumDisplacementX(FrameCount) = Data.TopStructure.SumDisplacementX(FrameCount-1) + Data.TopStructure.DisplacementX(FrameCount) ;
        Data.TopStructure.SumDisplacementY(FrameCount) = Data.TopStructure.SumDisplacementY(FrameCount-1) + Data.TopStructure.DisplacementY(FrameCount);
        Data.TopStructure.SumDisplacementYAdjusted(FrameCount) = Data.TopStructure.SumDisplacementY(FrameCount-1) + Data.TopStructure.DisplacementYAdjusted(FrameCount) ;

        Data.BottomStructure.SumDisplacementX(FrameCount) = Data.BottomStructure.SumDisplacementX(FrameCount-1) + Data.BottomStructure.DisplacementX(FrameCount) ;
        Data.BottomStructure.SumDisplacementY(FrameCount) = Data.BottomStructure.SumDisplacementY(FrameCount-1) + Data.BottomStructure.DisplacementY(FrameCount);
        Data.BottomStructure.SumDisplacementYAdjusted(FrameCount) =  Data.BottomStructure.SumDisplacementY(FrameCount-1) + Data.BottomStructure.DisplacementYAdjusted(FrameCount) ;
    end

    Data.Fiber.Length(FrameCount) = FiberData.Fiber.Length ;
    Data.Fiber.FiberFrame{FrameCount,1} = FiberData.Fiber.FiberFrame ;
    Data.Fiber.FiberFullFrame{FrameCount,1} = FiberData.Fiber.FiberFullFrame ;
    Data.Fiber.LengthAdjusted(FrameCount) = FiberData.Fiber.Length - (Data.TopStructure.Adjustment(FrameCount) - Data.BottomStructure.Adjustment(FrameCount)) ;
    Data.Fiber.PixelCount(FrameCount) = FiberData.Fiber.PixelCount ; 


    %% Plotting Update
    FrameCount2UpdatePlot = FrameCount2UpdatePlot+1 ; 
    if FrameCount2UpdatePlot >= FramesUpdatePlot || FrameCount == 1 || FrameCount == Parameters.Frames2Save
        figure(DICfig) ; 
        TPP_TensileTesting_AnalysisPlotUpdate_v3(NextFrame_Enhanced, ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, Data, FrameCount, Parameters.TotalFrames) ;
        FrameCount2UpdatePlot = 0 ; 
    end

    %% Set the Current Frame as Previous Frame
    LastFrame = NextFrame_Enhanced ;
    PixelCount = Data.Fiber.PixelCount(FrameCount) ; 
 
end

% FileNum = strsplit(Video.Name,'.') ;
% FileNum = string(FileNum(1)) ;
% figname = strjoin([ FileNum "- Figure Summary" ]) ;
% dirname = fullfile(Video.Path, "Summary Figures - v10") ;
% 
% if ~exist(dirname, 'dir')
%     mkdir(dirname)
% end
% 
% figsave = fullfile(dirname, figname);
% saveas(DICfig,figsave,'tiff');
% close(DICfig) ;
% 
% DataSavePath = fullfile(ExperimentDirectory,'Raw Data') ; 
% save(DataSavePath,"Data") ; 

toc ;

disp([ Video.Name, string(Video.NumFrames) ] ) ;

end