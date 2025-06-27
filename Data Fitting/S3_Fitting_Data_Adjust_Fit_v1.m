clear ; clc ; close ;

% Breaking down and fitting the stress strain curve
load('Stretch Experiment Data Fit - Sub 6-14.mat') ;

for n = 1:size(StretchExperimentData)

    CriticalPts = StretchExperimentData{n,4} ;

    if all(string(StretchExperimentData{n,4}) ~= "Atypical Curve") && size(CriticalPts,2) == 2

        Stress = StretchExperimentData{n,2} ;
        Strain = StretchExperimentData{n,3} ;

        % Load In Critical Data
        
        YieldIdx = CriticalPts(1) ;
        EqIdx = CriticalPts(2) ;

        % Assign Fitting Data
        YieldStress = Stress(YieldIdx) ;
        YieldStrain = Strain(YieldIdx) ;
        EqStress = Stress(EqIdx) ;
        EqStrain = Strain(EqIdx) ;

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
        FittingConstants = [ E1, YieldStrain, YieldStress, EqStrain, EqStress ] ;
        InitialFitVals = [ E1 200 0.16 ] ;
        [FittingValues, GoodnessOfFit] = TPPTT_MidStrainFittingFunc_v2(InitialFitVals, FittingConstants,...
            Stress, Strain) ;

        if GoodnessOfFit(1) < 0.8

            FittingConstants = [ E1, YieldStrain, YieldStress, EqStrain, EqStress] ;
            InitialFitVals = [1070 310 0.14] ;
            [FittingValues, GoodnessOfFit] = TPPTT_MidStrainFittingFunc_v2(InitialFitVals, FittingConstants,...
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

        pause(1) ;
        hold off ;

    end


end