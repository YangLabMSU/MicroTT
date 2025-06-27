function [] = TPP_TensileTesting_Script_MultiFolder(DataDirectory)


for Experiments = 1:1:length(DataDirectory)
    tic;

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
    DICfig.Position = [ 83, 144, 1770, 813 ] ;

    % Pixel Scan Range
    PixelRange.Vertical = 8 ;
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

    % Analyze Each Requested Frame
    %%

    for FrameCount = 1:1:Parameters.Frames2Save

        % Obtain the Proper Frame Number from RFNL
        Frame = Parameters.ReferenceFrameNumberList(FrameCount) ;
        Data.VideoFrame(FrameCount,:) = [ FrameCount Frame Frame*SecondsPerFrame ] ;
        Data.Time(FrameCount) = Frame*SecondsPerFrame ;

        % Read Next Frame in Sequence and Enhance Resolution for Proper
        % Dimension on Analysis
        CurrentFrame = read(Video, Frame) ;
        Rows = size(CurrentFrame,1) ;
        CurrentFrame_Enhanced = imresize(CurrentFrame, [ Rows*Parameters.ResolutionMultiplier , NaN ]) ;

        if FrameCount == 1

            LastFrame = CurrentFrame_Enhanced ;
            TGBWL = TGBWI ;
            BGBWL = BGBWI ;
            FGBWL = Grids.Fiber.InitialBW ;
            FGDets = Fiber_Initial_Evaluation_v1(FGBWL) ;

        end

        % Bulk Grid Matching

        % Top Grid
        [ROI_Top{FrameCount+1,1}, TopData] = Analysis_Grid_Matching_v0(CurrentFrame_Enhanced, TGBWI, TGBWL, ROI_Top{FrameCount,1}, PixelRange) ;
        TGBWL = TopData.CurrentFrameBW ; % TGBWL: Top Grid Black & White Last -- In Outpout Data

        % Bottom Grid
        [ROI_Bottom{FrameCount+1,1}, BottomData] = Analysis_Grid_Matching_v0(CurrentFrame_Enhanced, BGBWI, BGBWL, ROI_Bottom{FrameCount,1}, PixelRange) ;
        BGBWL = BottomData.CurrentFrameBW ; % BGBWL: Bottom Grid Black & White Last -- In Outpout Data

        % Fiber Grid Evaluation
        FiberData = Fiber_Evaluation_v1(ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, CurrentFrame_Enhanced, FGBWL, FGDets, Grids) ;
        FGBWL = FiberData.FiberGridBW ;

        % Edge Adjustment Analysis
        Pixels2Find = 4 ;
        [TopAdjustment, BottomAdjustment] = Edge_Adjustment_v0(TGBWL, BGBWL, Grids, Pixels2Find) ;

        % Data Organization
        if FrameCount == 1
            TopAdjustInitial = TopAdjustment ;
            BottomAdjustInitial = BottomAdjustment ;
        end

        Data.TopStructure.DisplacementX(FrameCount) = TopData.DisplacementX ;
        Data.TopStructure.DisplacementY(FrameCount) = TopData.DisplacementY ;
        Data.TopStructure.NumberPixelDifference(FrameCount) = TopData.NormalizedPixelDifference ;
        Data.TopStructure.LastFrameNumberPixelDifference(FrameCount) = TopData.LastFrameNormalizedPixelDifference ;
        Data.TopStructure.EdgeLine(FrameCount) = TopAdjustment + ROI_Top{FrameCount+1,1}(1,1) ;
        Data.TopStructure.Adjustment(FrameCount) = TopAdjustment - TopAdjustInitial ;
        Data.TopStructure.DisplacementYAdjusted(FrameCount) = TopData.DisplacementY - Data.TopStructure.Adjustment(FrameCount) ;

        Data.BottomStructure.DisplacementX(FrameCount) = BottomData.DisplacementX ;
        Data.BottomStructure.DisplacementY(FrameCount) = BottomData.DisplacementY ;
        Data.BottomStructure.NumberPixelDifference(FrameCount) = BottomData.NormalizedPixelDifference ;
        Data.BottomStructure.LastFrameNumberPixelDifference(FrameCount) = BottomData.LastFrameNormalizedPixelDifference ;
        Data.BottomStructure.EdgeLine(FrameCount) = BottomAdjustment + ROI_Bottom{FrameCount+1,1}(1,1) ;
        Data.BottomStructure.Adjustment(FrameCount) = BottomAdjustment - BottomAdjustInitial ;
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
        Data.Fiber.AverageWidth{FrameCount} = FiberData.Fiber.AverageWidth ;

        % Plotting Update
        FrameCount2UpdatePlot = FrameCount2UpdatePlot+1 ;
        if FrameCount2UpdatePlot >= FramesUpdatePlot || FrameCount == 1 || FrameCount == Parameters.Frames2Save
            figure(DICfig) ;
            TPP_TensileTesting_AnalysisPlotUpdate_v3(CurrentFrame_Enhanced, ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, Data, FrameCount, Parameters.TotalFrames) ;
            FrameCount2UpdatePlot = 0 ;
        end

        %% Set the Current Frame as Previous Frame
        LastFrame = CurrentFrame_Enhanced ;
        PixelCount = Data.Fiber.PixelCount(FrameCount) ;

        % Check for Fracture events
        if abs(Data.TopStructure.DisplacementY(FrameCount)) < 20 && abs(Data.BottomStructure.DisplacementY(FrameCount)) > 20
            disp(["Suspected Fracture" string(Video.Name) ]) ;
            FractureCheck = "Yes";
        end

        if FractureCheck == "Yes"
            FractureCount = FractureCount + 1;
            if FractureCount == 15
                break ;
            end
        end

    end

    FileNum = strsplit(Video.Name,'.') ;
    FileNum = string(FileNum(1)) ;
    figname = strjoin([ FileNum "- Summary" ]) ;
    dirname = fullfile(Video.Path, "Summary Figures - v10") ;

    if ~exist(dirname, 'dir')
        mkdir(dirname)
    end

    figsave = fullfile(dirname, figname);
    saveas(DICfig,figsave,'tiff');
    close(DICfig) ;

    DataSavePath = fullfile(ExperimentDirectory,'Raw Data') ;
    save(DataSavePath,"Data") ;

    toc ;

    disp([ Video.Name, string(Video.NumFrames) ] ) ;

end

end
