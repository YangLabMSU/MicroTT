clear ; clc ; close ;

% Breaking down and fitting the stress strain curve
% load('All Stretch Experiments Table.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ;
% load('Stretch Experiment Data Fit.mat') ;

% Breaking down and fitting the stress strain curve
load("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat") ;


for n = 1:size(StretchExperimentData)

    if string(StretchExperimentData{n,4}) ~= "Adjust Fit Style"

        Stress = StretchExperimentData{n,2} ;
        Strain = StretchExperimentData{n,3} ;

        % Load In Critical Data
        CriticalPts = StretchExperimentData{n,4} ;
        %CriticalPts = [ 40 50 105 ] ; 
        YieldIdx = CriticalPts(1) ;
        EqIdx = CriticalPts(2) ;
        FPIdx = CriticalPts(3) ;

        % Assign Fitting Data
        YieldStress = Stress(YieldIdx) ;
        YieldStrain = Strain(YieldIdx) ;
        EqStress = Stress(EqIdx) ;
        EqStrain = Strain(EqIdx) ;
        FPStress = Stress(FPIdx) ;
        FPStrain = Strain(FPIdx) ;

        % Linear Index
        LinIdx = 1:ceil(0.5*YieldIdx) ;
        LinStrain = Strain(LinIdx) ;
        LinStress = Stress(LinIdx) ;

        % Fit Youngs Modulus to Data Prior to Yield Point
        % Fit a linear model to the data
        LFT = fittype({'x'}) ; % linear fit type
        LinearModel = fit(LinStrain, LinStress, LFT);
        E1 = LinearModel.a ; % Youngs Modulus
        LSP = Strain(1:YieldIdx) ; % Linear Strain Plot Points
        LinMod = E1*LSP ; % Linear Model

        % Plotting
        plot(Strain, Stress, '-b', 'LineWidth', 3) ; hold on;
        plot(LSP, LinMod, '--r', 'LineWidth', 2) ;

        % Put Fitting Constants into a vector
        FittingConstants = [ E1, YieldStrain, YieldStress, EqStrain, EqStress, FPStrain, FPStress ] ;
        InitialFitVals = [ E1 200 0.16 550 0.75 ] ;
        %InitialFitVals = [ 20 50 0.15 10 0.8 ] ;
        [FittingValues, GoodnessOfFit] = TPPTT_LargeStrainFittingFunc_v2(InitialFitVals, FittingConstants,...
            Stress, Strain) ;

        if GoodnessOfFit(1) < 0.8
            
            FittingConstants = [ E1, YieldStrain, YieldStress, EqStrain, EqStress, FPStrain, FPStress ] ;
            InitialFitVals = [1070 310 0.14 990 0.75] ;
            [FittingValues, GoodnessOfFit] = TPPTT_LargeStrainFittingFunc_v2(InitialFitVals, FittingConstants,...
                Stress, Strain) ;

        end

        if GoodnessOfFit(1) == -Inf

            x = 1 ;

        end

        %CurveFitValues = FittingValues ;

        datatxt = sprintf("E1: %0.3f, E2: %0.3f, lambda_1: %0.3f, E3: %0.3f, lambda_2: %0.3f", FittingValues) ;
        fittxt = sprintf("r^2: %0.3f, rmse: %0.3f", GoodnessOfFit) ;

        disp(datatxt) ;
        disp(fittxt) ;

        StretchExperimentData{n,5} = FittingValues ;
        StretchExperimentData{n,6} = GoodnessOfFit ;

        pause(0.5) ;
        hold off ;

    end


end

%save("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat", "StretchExperimentData") ;