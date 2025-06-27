clear ; clc ; close ;

% Data Processing -- Folder by Folder data Evaluation
% 1) Load Data
% 2) Convert Data to Stress vs. Strain
% 3) Evaluate and Smooth Data -- eliminate outliers!

% Load In Folder Containing All Experiments
DataDirectory = LoadRawDataExperimentDirectory() ;

% Standard P2MR
Pixel2MicronRatio = 0.33 ;

for n = 1 %:size(DataDirectory,1)

    DataPath = fullfile(DataDirectory(n,1), "Raw Data.mat") ; load(DataPath) ;
    ParamPath = fullfile(DataDirectory(n,1), "Parameters.mat") ; load(ParamPath) ;
    Parameters.BeamThickness = double(Parameters.BeamThickness) ; 

    if Parameters.BeamThickness == 10 

        BeamStiffness = 18.7 ; 
        disp(BeamStiffness) ;
        
    elseif Parameters.BeamThickness == 15

        BeamStiffness = 42.1 ; % uN / um
        disp(BeamStiffness) ;

    elseif Parameters.BeamThickness == 20

        BeamStiffness = 95.8 ; % uN / um
        disp(BeamStiffness) ;

    elseif Parameters.BeamThickness == 25

        BeamStiffness = 187.5 ; 
        disp(BeamStiffness) ;

    end

    % Set Smooth Factor Based on the Displacement Rates (um/s)
    if Parameters.DisplacementRate == "1" || Parameters.DisplacementRate == "2"

        SmoothFactor = 15 ; 

    elseif Parameters.DisplacementRate == "4"

        SmoothFactor = 8 ; 

    elseif double(Parameters.DisplacementRate) < 1

        SmoothFactor = 20 ; 

    elseif double(Parameters.DisplacementRate) > 4

        SmoothFactor = 3 ; 

    end
    

    Time = Data.Time ;
    TopPixDisp = Data.TopStructure.SumDisplacementYAdjusted ;
    BotPixDisp = Data.BottomStructure.SumDisplacementYAdjusted ;
    FiberLength = Data.Fiber.LengthAdjusted ;

    FiberArea = Parameters.FiberArea ;
    P2MR_Adj = Pixel2MicronRatio / Parameters.ResolutionMultiplier ;
    TopDisplacement = Data.TopStructure.SumDisplacementYAdjusted * P2MR_Adj ;
    BotDisplacement = Data.BottomStructure.SumDisplacementYAdjusted * P2MR_Adj ;
    FiberLength = Data.Fiber.LengthAdjusted * P2MR_Adj ;

    % Calculating Strain
    % Fiber Strain
    FiberStrain = (FiberLength - FiberLength(1)) / (FiberLength(1)) ;

    % Plate Strain
    PlateStrain = (TopDisplacement - BotDisplacement) / FiberLength(1) ;

    % Force and Stress Calculation
    Force = BotDisplacement * BeamStiffness ;
    Stress = Force / double(FiberArea) ;

    %PlateStrain = smooth(smooth(PlateStrain, SmoothFactor),SmoothFactor) ;
    FiberStrain = smooth(smooth(FiberStrain, SmoothFactor),SmoothFactor) ; 
    Stress = smooth(smooth(Stress, SmoothFactor),SmoothFactor) ;

    ExpDist = Parameters.DisplacementDistance ;

    PlotFig = figure() ;
    PlotFig.Units = 'Normalized' ;
    PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
    TPPTT_Post_Process_Plotting_v1(Time, TopDisplacement, ExpDist, FiberStrain, PlateStrain, Force, Stress) ;

end
