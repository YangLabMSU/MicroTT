function [ SmoothProcessedData, ProcessedData ] = TPPTTDataProcessor_NoAdjust(Data, Parameters)

    % Set Evaluation Constants
    Parameters.Pixel2MicronRatio = 0.33 ;

    % Load in Time
    SmoothProcessedData.Time = Data.Time' ;
    ProcessedData.Time = Data.Time' ;

    % Load in Main Measurements
    % TopPixDisp = Data.TopStructure.SumDisplacementYAdjusted ;
    % BotPixDisp = Data.BottomStructure.SumDisplacementYAdjusted ;
    % FiberLength = Data.Fiber.LengthAdjusted ;

    TopPixDisp = Data.TopStructure.SumDisplacementY ;
    BotPixDisp = Data.BottomStructure.SumDisplacementY ;
    FiberLength = Data.Fiber.Length ;

    % Retrieve Processing Parameters
    FiberArea = Parameters.FiberArea ;
    Parameters.P2MR_Adj = Parameters.Pixel2MicronRatio / Parameters.ResolutionMultiplier ;

    % Calculate Micron Displacement and Length
    % TopDisplacement = Data.TopStructure.SumDisplacementYAdjusted * Parameters.P2MR_Adj ;
    % TopDisplacement = TopDisplacement - TopDisplacement(1) ; 
    % BotDisplacement = Data.BottomStructure.SumDisplacementYAdjusted * Parameters.P2MR_Adj ;
    % BotDisplacement = BotDisplacement - BotDisplacement(1) ;  
    % FiberLength = Data.Fiber.LengthAdjusted * Parameters.P2MR_Adj ;

    TopDisplacement = Data.TopStructure.SumDisplacementY * Parameters.P2MR_Adj ;
    TopDisplacement = TopDisplacement - TopDisplacement(1) ; 
    BotDisplacement = Data.BottomStructure.SumDisplacementY * Parameters.P2MR_Adj ;
    BotDisplacement = BotDisplacement - BotDisplacement(1) ;   
    FiberLength = Data.Fiber.Length * Parameters.P2MR_Adj ;
    InitialFiberLength = FiberLength(1) ; 

    % Calculating Strain
    % Fiber Strain
    FiberStrain = (FiberLength - InitialFiberLength) / InitialFiberLength ;

    % Plate Strain
    PlateStrain = (TopDisplacement - BotDisplacement) / InitialFiberLength ;

    % Force and Stress Calculation
    Force = BotDisplacement * Parameters.BeamStiffness ;
    Stress = Force / double(FiberArea) ;

    SmoothFactor = Parameters.SmoothFactor ; 

    % Smooth and Assign Processed Data
    ProcessedData.TopDisplacement = smooth(smooth(TopDisplacement, SmoothFactor),SmoothFactor) ; 
    ProcessedData.BottomDisplacement = smooth(smooth(BotDisplacement, SmoothFactor),SmoothFactor) ; 
    ProcessedData.FiberLength = smooth(smooth(FiberLength, SmoothFactor),SmoothFactor) ; 
    ProcessedData.PlateStrain = smooth(smooth(PlateStrain, SmoothFactor),SmoothFactor) ; 
    ProcessedData.FiberStrain = smooth(smooth(FiberStrain, SmoothFactor),SmoothFactor) ;
    ProcessedData.Force = smooth(smooth(Force, SmoothFactor), SmoothFactor) ; 
    ProcessedData.Stress = smooth(smooth(Stress, SmoothFactor),SmoothFactor) ;

    SmoothProcessedData.TopDisplacement = smooth(smooth(TopDisplacement, SmoothFactor),SmoothFactor) ; 
    SmoothProcessedData.BottomDisplacement = smooth(smooth(BotDisplacement, SmoothFactor),SmoothFactor) ; 
    SmoothProcessedData.FiberLength = smooth(smooth(FiberLength, SmoothFactor),SmoothFactor) ; 
    SmoothProcessedData.PlateStrain = smooth(smooth(PlateStrain, SmoothFactor),SmoothFactor) ; 
    SmoothProcessedData.FiberStrain = smooth(smooth(FiberStrain, SmoothFactor),SmoothFactor) ;
    SmoothProcessedData.Force = smooth(smooth(Force, SmoothFactor), SmoothFactor) ; 
    SmoothProcessedData.Stress = smooth(smooth(Stress, SmoothFactor),SmoothFactor) ;

    % Smooth and Assign Data Parameters
    SmoothProcessedData.Parameters = Parameters ;
    ProcessedData.Parameters = Parameters ;


end
