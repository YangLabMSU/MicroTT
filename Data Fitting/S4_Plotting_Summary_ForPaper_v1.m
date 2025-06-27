clear ; clc ; close ;

% load data
load('Stretch Experiment Data Fit - v2.mat') ;

% Plotting and Evaluating Data
% Set Up Figure
PlotFig = figure('Units', 'Normalized', 'Position', [0.2,0.15,0.6, 0.675]) ;

n = 30 ;

    Stress = StretchExperimentData{n,2} ;
    Strain = StretchExperimentData{n,3} ;

    % Load In Critical Data
    CriticalPts = StretchExperimentData{n,4} ;

    if size(CriticalPts,2) == 3

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

        % Fitting Values
        FittingValues = StretchExperimentData{n,5} ;
        E1 = FittingValues(1) ;
        E2 = FittingValues(2) ;
        Lam1 = FittingValues(3) ;
        E3 = FittingValues(4) ;
        Lam2 = FittingValues(5) ;

        % Generate Linear Curve
        LinStrain = Strain(1:YieldIdx) ;
        LinStress = E1*LinStrain ;

        % Generate Fit Curve
        StrainFit = abs(Strain) ;
        StressFit = E1.*StrainFit - E2*exp(-(Lam1./StrainFit)) - E3*exp(-(Lam2./StrainFit)) ;

    elseif size(CriticalPts,2) == 2

        YieldIdx = CriticalPts(1) ;
        EqIdx = CriticalPts(2) ;

        % Assign Fitting Data
        YieldStress = Stress(YieldIdx) ;
        YieldStrain = Strain(YieldIdx) ;
        EqStress = Stress(EqIdx) ;
        EqStrain = Strain(EqIdx) ;

        % Fitting Values
        FittingValues = StretchExperimentData{n,5} ;
        E1 = FittingValues(1) ;
        E2 = FittingValues(2) ;
        Lam1 = FittingValues(3) ;

        % Generate Linear Curve
        LinStrain = Strain(1:YieldIdx) ;
        LinStress = E1*LinStrain ;

        % Generate Fit Curve
        StrainFit = abs(Strain) ;
        StressFit = E1.*StrainFit - E2*exp(-(Lam1./StrainFit)) ;

        E3 = "Neglected, 2 term" ;
        Lam2 = "Neglected, 2 term" ;

    end

    GoodnessOfFit = StretchExperimentData{n,6} ;
    Rsqrd = GoodnessOfFit(1) ;
    RMSE = GoodnessOfFit(2) ;

    % Parameters
    Parameters = StretchExperimentData{n,1} ;
    Materials = Parameters(1) ;
    Substrate = Parameters(2) ;
    TestDate = Parameters(3) ;
    Conditions = Parameters(4) ;
    ArrayPosition = Parameters(5) ;
    BeamStiffness = Parameters(7) ;
    Power = (double(Parameters(8))/100)*50 ;
    WriteSpeed = Parameters(9) ;
    FWidth = Parameters(10) ;
    FHeight = Parameters(11) ;
    Slice = Parameters(12) ;
    Hatch = Parameters(13) ;
    Style = Parameters(14) ;
    SEMArea = Parameters(15) ;
    FiberLength = Parameters(16) ;
    StrainDistance = Parameters(17) ;
    StrainRate = Parameters(18) ;


    % Plotting
    subplot(1,3,[1 2])
    % Original Stress Strian Data
    plot(Strain, Stress, '-', 'color', '#11029e','Linewidth', 5, 'DisplayName', ...
        'Experiment Data') ; hold on ;

    % Plot the Linear Portion of the Curve
    plot(LinStrain, LinStress, '-.', 'color', '#b80404', 'LineWidth', 4, 'DisplayName',...
        "Youngs Modulus Fit") ;

    % Mark the Yield, Equilibrium Points
    plot(YieldStrain, YieldStress, 'x', 'color', '#b80404', 'LineWidth', 4, ...
        'MarkerSize', 15, 'DisplayName', 'Yield Point') ;

    % Plot Fitting Data
    plot(StrainFit, StressFit, '--','LineWidth', 4, 'Color', "#00ed2f", 'DisplayName',...
        "Model Fit") ;

    % Plot Details
    legend('Location', 'northwest') ;
    legend('boxoff') ; box off; grid on; ax = gca ;
    set(ax, 'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'bold',...
        'LineWidth', 1.5, 'TickLength', [ 0.015, 0.2 ]);

    % Titles and Axes Lables
    title('TPPTT Curve Fitting') ;
    xlabel('Strain') ;
    ylabel('Stress (uN/um^2)') ;






