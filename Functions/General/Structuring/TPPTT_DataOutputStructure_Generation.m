function [Data] = TPPTT_DataOutputStructure_Generation(Data, ROI_Top, TopData, ROI_Bottom, BottomData, FiberData, FrameCount, Adjustments)

Data.TopStructure.DisplacementX(FrameCount) = TopData.DisplacementX ;
Data.TopStructure.DisplacementY(FrameCount) = TopData.DisplacementY ;
Data.TopStructure.NumberPixelDifference(FrameCount) = TopData.NormalizedPixelDifference ;
Data.TopStructure.LastFrameNumberPixelDifference(FrameCount) = TopData.LastFrameNormalizedPixelDifference ;
Data.TopStructure.EdgeLine(FrameCount) = Adjustments.TopAdjustment + ROI_Top{FrameCount+1,1}(1,1) ;
Data.TopStructure.Adjustment(FrameCount) = Adjustments.TopAdjustment - Adjustments.TopAdjustInitial ;
Data.TopStructure.DisplacementYAdjusted(FrameCount) = TopData.DisplacementY - Data.TopStructure.Adjustment(FrameCount) ;

Data.BottomStructure.DisplacementX(FrameCount) = BottomData.DisplacementX ;
Data.BottomStructure.DisplacementY(FrameCount) = BottomData.DisplacementY ;
Data.BottomStructure.NumberPixelDifference(FrameCount) = BottomData.NormalizedPixelDifference ;
Data.BottomStructure.LastFrameNumberPixelDifference(FrameCount) = BottomData.LastFrameNormalizedPixelDifference ;
Data.BottomStructure.EdgeLine(FrameCount) = Adjustments.BottomAdjustment + ROI_Bottom{FrameCount+1,1}(1,1) ;
Data.BottomStructure.Adjustment(FrameCount) = Adjustments.BottomAdjustment - Adjustments.BottomAdjustInitial ;
Data.BottomStructure.DisplacementYAdjusted(FrameCount) = ...
    BottomData.DisplacementY - Data.BottomStructure.Adjustment(FrameCount) ;

if FrameCount == 1
    Data.TopStructure.SumDisplacementX(FrameCount) = Data.TopStructure.DisplacementX(FrameCount) ;
    Data.TopStructure.SumDisplacementY(FrameCount) = Data.TopStructure.DisplacementY(FrameCount) ;
    Data.TopStructure.SumDisplacementYAdjusted(FrameCount) = Data.TopStructure.DisplacementYAdjusted(FrameCount) ;

    Data.BottomStructure.SumDisplacementX(FrameCount) = Data.BottomStructure.DisplacementX(FrameCount) ;
    Data.BottomStructure.SumDisplacementY(FrameCount) = Data.BottomStructure.DisplacementY(FrameCount);
    Data.BottomStructure.SumDisplacementYAdjusted(FrameCount) = Data.BottomStructure.DisplacementYAdjusted(FrameCount) ;
else
    Data.TopStructure.SumDisplacementX(FrameCount) = ...
        Data.TopStructure.SumDisplacementX(FrameCount-1) + Data.TopStructure.DisplacementX(FrameCount) ;
    Data.TopStructure.SumDisplacementY(FrameCount) = ...
        Data.TopStructure.SumDisplacementY(FrameCount-1) + Data.TopStructure.DisplacementY(FrameCount);
    Data.TopStructure.SumDisplacementYAdjusted(FrameCount) = ...
        Data.TopStructure.SumDisplacementY(FrameCount-1) + Data.TopStructure.DisplacementYAdjusted(FrameCount) ;

    Data.BottomStructure.SumDisplacementX(FrameCount) = ...
        Data.BottomStructure.SumDisplacementX(FrameCount-1) + Data.BottomStructure.DisplacementX(FrameCount) ;
    Data.BottomStructure.SumDisplacementY(FrameCount) = ...
        Data.BottomStructure.SumDisplacementY(FrameCount-1) + Data.BottomStructure.DisplacementY(FrameCount);
    Data.BottomStructure.SumDisplacementYAdjusted(FrameCount) =  ...
        Data.BottomStructure.SumDisplacementY(FrameCount-1) + Data.BottomStructure.DisplacementYAdjusted(FrameCount) ;
end

Data.Fiber.Length(FrameCount) = FiberData.Fiber.Length ;
Data.Fiber.FiberFrame{FrameCount,1} = FiberData.Fiber.FiberFrame ;
Data.Fiber.FiberFullFrame{FrameCount,1} = FiberData.Fiber.FiberFullFrame ;
Data.Fiber.LengthAdjusted(FrameCount) = ...
    FiberData.Fiber.Length - (Data.TopStructure.Adjustment(FrameCount) - Data.BottomStructure.Adjustment(FrameCount)) ;
Data.Fiber.PixelCount(FrameCount) = FiberData.Fiber.PixelCount ;
Data.Fiber.AverageWidth{FrameCount} = FiberData.Fiber.AverageWidth ;

end
