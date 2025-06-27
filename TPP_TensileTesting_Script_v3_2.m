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


for Experiments = 1:1:length(DataDirectory)
    totaltimestart = tic;

    Data = [] ;
    ROI_Top = [] ;
    ROI_Bottom = [] ;
    Grids = [] ;
    RawData = [] ;
    Parameters = [] ;
    Video = [] ;

    FractureCount = 0 ;
    FractureCheck = "No" ;

    ExperimentDirectory = DataDirectory(Experiments) ;
    load(fullfile(ExperimentDirectory,"Grid Data.mat")) ;
    load(fullfile(ExperimentDirectory,"Video and Parameters.mat")) ;

    % Generate a Figure
    DICfig = figure() ;
    DICfig.Position = [ 1359,146,1177,787 ] ;

    % Pixel Scan Range
    PixelRange.Vertical = 8 ;
    PixelRange.Horizontal = 3 ;

    % Frame Rate Multiplier. Duration of Video (s) / Total Video Frames
    SecondsPerFrame = Video.Duration / Video.NumFrames ;

    % Initial BW Images
    TGBWI = Grids.TopStructure.InitialBW ; % Top Grid BW Initial
    BGBWI = Grids.BottomStructure.InitialBW ; % Top Grid BW Initial

    % Initial Grid Coordinates
    ROI_Top{1,1} = Grids.TopStructure.Coordinates ;
    ROI_Bottom{1,1} = Grids.BottomStructure.Coordinates ;

    %FramesUpdatePlot = round(Parameters.Frames2Save / 100) ;
    FramesUpdatePlot = 50 ;
    FrameCount2UpdatePlot = 0 ;

    
    % Analyze Each Requested Frame
    for FrameCount = 1:1:Parameters.Frames2Save
       try 
        Total_Timing_Start = tic ; 

        % Obtain the Proper Frame Number from RFNL
        Frame = Parameters.ReferenceFrameNumberList(FrameCount) ;
        Data.VideoFrame(FrameCount,:) = [ FrameCount Frame...
            Frame*SecondsPerFrame ] ;

        Data.Time(FrameCount) = Frame*SecondsPerFrame ;

        % Read Next Frame in Sequence and Enhance Resolution for Proper
        % Dimension on Analysis
        CurrentFrame = read(Video, Frame) ;
        Rows = size(CurrentFrame,1) ;
        CurrentFrame_Enhanced = imresize(CurrentFrame, ...
            [ Rows*Parameters.ResolutionMultiplier , NaN ]) ;

        if FrameCount == 1

            LastFrame = CurrentFrame_Enhanced ;
            TGBWL = TGBWI ;
            BGBWL = BGBWI ;
            FGBWL = Grids.Fiber.InitialBW ;
            FGDets = Fiber_Initial_Evaluation_v1(FGBWL) ;

        end

        % Bulk Grid Matching
        tic ;

        if FrameCount < 50

            NPDRangeTop = 0.1 ;
            NPDRangeBottom = 0.1 ; 

        else

            NPDRangeTop = 1.5*mean(Data.TopStructure.NumberPixelDifference) ;  
            if NPDRangeTop < 0.1 
                NPDRangeTop = 0.1 ; 
            end

            NPDRangeBottom = 1.5*mean(Data.BottomStructure.NumberPixelDifference) ;
            if NPDRangeBottom < 0.1 
                NPDRangeBottom = 0.1 ; 
            end
            
        end

        % Top Grid
        [ROI_Top{FrameCount+1,1}, TopData] = ...
            Analysis_Grid_Matching_v1(CurrentFrame_Enhanced, ...
            TGBWI, TGBWL, ROI_Top{FrameCount,1}, PixelRange, NPDRangeTop) ;

        % TGBWL: Top Grid Black & White Last -- In Outpout Data
        TGBWL = TopData.CurrentFrameBW ;

        % Bottom Grid
        [ROI_Bottom{FrameCount+1,1}, BottomData] = ...
            Analysis_Grid_Matching_v1(CurrentFrame_Enhanced, ...
            BGBWI, BGBWL, ROI_Bottom{FrameCount,1}, PixelRange, NPDRangeBottom) ;

        % BGBWL: Bottom Grid Black & White Last -- In Outpout Data
        BGBWL = BottomData.CurrentFrameBW ;

        Timing(FrameCount,1) = toc ; 

        tic ; 

        % Fiber Grid Evaluation
        FiberData = Fiber_Evaluation_v2(ROI_Top{FrameCount+1,1}, ...
            ROI_Bottom{FrameCount+1,1}, CurrentFrame_Enhanced, ...
            FGBWL, FGDets, Grids) ;
       

        if isempty(FiberData)

            FiberData.Fiber.Length = Data.Fiber.Length(FrameCount-1) ;
            FiberData.Fiber.FiberFrame = Data.Fiber.FiberFrame{FrameCount-1,1} ;
            FiberData.Fiber.FiberFullFrame = Data.Fiber.FiberFullFrame{FrameCount-1,1} ;
            FiberData.Fiber.PixelCount = Data.Fiber.PixelCount(FrameCount-1)  ;
            FiberData.Fiber.AverageWidth = Data.Fiber.AverageWidth{FrameCount-1}  ;

        else

            FGBWL = FiberData.FiberGridBW ;

        end

        Timing(FrameCount,2) = toc ; 

        tic ; 

        % Edge Adjustment Analysis
        Pixels2Find = 4 ;
        [Adjustments.TopAdjustment, Adjustments.BottomAdjustment] = Edge_Adjustment_v0(TGBWL, ...
            BGBWL, Grids, Pixels2Find) ;

        Timing(FrameCount, 3) = toc ;

        tic ;

        % Data Organization
        if FrameCount == 1
            Adjustments.TopAdjustInitial = Adjustments.TopAdjustment ;
            Adjustments.BottomAdjustInitial = Adjustments.BottomAdjustment ;
        end

        Data = TPPTT_DataOutputStructure_Generation(Data, ROI_Top, TopData, ROI_Bottom, BottomData, FiberData, FrameCount, Adjustments) ;

        Timing(FrameCount,4) = toc ; 

        tic ; 

        % Plotting Update
        FrameCount2UpdatePlot = FrameCount2UpdatePlot+1 ;
        if FrameCount2UpdatePlot >= FramesUpdatePlot ...
                || FrameCount == 1 ...
                || FrameCount == Parameters.Frames2Save

            figure(DICfig) ;
            TPP_TensileTesting_AnalysisPlotUpdate_v3(CurrentFrame_Enhanced, ROI_Top{FrameCount+1,1}, ...
                ROI_Bottom{FrameCount+1,1}, Data, FrameCount, Parameters.TotalFrames) ;
            FrameCount2UpdatePlot = 0 ;

        end

        Timing(FrameCount, 5) = toc ; 

        %% Set the Current Frame as Previous Frame
        LastFrame = CurrentFrame_Enhanced ;
        PixelCount = Data.Fiber.PixelCount(FrameCount) ;

        % Check for Fracture events
        if abs(Data.TopStructure.DisplacementY(FrameCount)) < 20 ...
                && abs(Data.BottomStructure.DisplacementY(FrameCount)) > 20

            disp(["Suspected Fracture" string(Video.Name) ]) ;
            FractureCheck = "Yes";

        end

        if FractureCheck == "Yes"

            FractureCount = FractureCount + 1;

            if FractureCount == 2
                break ;
            end

        end

        Timing(FrameCount, 6) = toc(Total_Timing_Start) ; 

        %disp([ "Grid" "Fiber" "Edge" "Data" "Plotting" "Total" ; Timing(FrameCount, :) ]) ; 
       catch 

           
       end
    end

    Data.AnaylsisTiming = [ "Grid" "Fiber" "Edge" "Data" "Plotting" "Total" ; Timing ] ; 

    FileNum = strsplit(Video.Name,'.') ;
    FileNum = string(FileNum(1)) ;
    figname = strjoin([ FileNum "- Summary" ]) ;
    dirname = fullfile(Video.Path, "Summary Figures - v12") ;

    if ~exist(dirname, 'dir')
        mkdir(dirname)
    end

    figsave = fullfile(dirname, figname);
    saveas(DICfig,figsave,'tiff');
    close(DICfig) ;

    DataSavePath = fullfile(ExperimentDirectory,'Raw Data') ;
    save(DataSavePath,"Data") ;

    totaltime = toc(totaltimestart) ;

    disp([ Video.Name, string(Video.NumFrames), ...
        string(Parameters.Frames2Save) totaltime] ) ;

end
