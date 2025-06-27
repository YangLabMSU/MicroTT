clear ; clc ; close all ;

load('All_IPS_LargeStrain_Data_TrueOgden_v6.mat') ;
All_IPS_Data = All_IPS_Data_Ogden ;

for n = 2 %:size(All_IPS_Data,1)
    %% Data and Parameter Extraction 

    % Load in Stress and Strain Data
    Stress = All_IPS_Data{n,2} ;
    Strain = All_IPS_Data{n,3} ;
    Lambda = 1 + Strain ;

    % Load In Critical Data
    CriticalPts = All_IPS_Data{n,4} ;

    % Yield Data
    YieldData = All_IPS_Data{n,5} ;

    % Ogden Fitting Values
    FittingValues = All_IPS_Data{n,6} ;

    % Load Parameters
    Parameters = All_IPS_Data{n,1} ;

    % Goodness of Fit
    GoodnessOfFit = All_IPS_Data{n,7} ;

    %% Plotting 

    % Set Up Figure
    PlotFig = figure('Units', 'Normalized', 'Position', [0.2,0.15,0.6, 0.675]) ; % Adjust if needed

    % Yield Idx
    YieldIdx = CriticalPts(1) ;

    % Yield Point 
    YieldStress = Stress(YieldIdx) ;
    YieldStrain = Strain(YieldIdx) ;

    % Ogden Fitting Parameters
    mu = FittingValues(1:2:end);     % Odd indices: mu_k
    alpha = FittingValues(2:2:end);  % Even indices: alpha_k

    % Generate Fitted Model
    FittedStress = zeros(size(Lambda));

    % Compute stress for each term
    for k = 1:length(mu)
        FittedStress = FittedStress + (2 * mu(k) / alpha(k)) .* ...
            (Lambda.^alpha(k) - (1 ./ sqrt(Lambda)).^alpha(k));
    end

    FittedStress = FittedStress ./ (1+Strain) ;

    % Goodness of Fit Statistics
    Rsqrd = GoodnessOfFit(1) ;
    RMSE = GoodnessOfFit(2) ;

    % Assign Parameters for Writing
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
    plot(Strain, Stress, '-', 'color', '#11029e', 'Linewidth', 5, 'DisplayName', ...
        'Experiment Data') ; hold on ;

    % Plot the Linear Portion of the Curve
    plot(Strain, FittedStress, '-.', 'color', '#b80404', 'LineWidth', 4, 'DisplayName',...
        "Ogden Model") ;

    % Mark the Yield, Equilibrium Points
    plot(YieldStrain, YieldStress, 'x', 'color', '#b80404', 'LineWidth', 4, ...
        'MarkerSize', 15, 'DisplayName', 'Yield Point') ;

    % Plot Details
    legend('Location', 'northwest') ;
    legend('boxoff') ; box off; grid on; ax = gca ;
    set(ax, 'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'bold',...
        'LineWidth', 1.5, 'TickLength', [ 0.015, 0.2 ]);

    % Titles and Axes Lables
    title('TPPTT Curve Fitting') ;
    xlabel('Strain') ;
    ylabel('Stress (MPa)') ;

    hold off ;

    subplot(1,3,3) ;
    cla ;
    axis off;

    % Adding Experiment Details Text
    ExpMaterialString = sprintf("Material: %s", Materials) ;
    ExpSubString = sprintf("Substrate: %s", Substrate ) ;
    ExpTDString = sprintf("Test Date: %s", TestDate) ;
    ExpCondString = sprintf("Conditions: %s", Conditions ) ;
    ExpArrayString = sprintf("Array Position: %s", ArrayPosition) ;
    ExpWSString = sprintf("Writing Speed (mm/s): %s", WriteSpeed ) ;
    ExpWPString = sprintf("Writing Power (mW): %0.2f", Power ) ;
    ExpFWHString = sprintf("Fiber Design Width x Height (um): %s x %s", FWidth, FHeight) ;
    ExpSliceHatchString = sprintf("Fiber Slice x Hatch (um): %s x %s", ...
        Slice, Hatch) ;
    ExpHatchStyleString = sprintf("Fiber Hatch Style: %s", Style) ;
    ExpAreaString = sprintf("Fiber Area (um^2): %s", SEMArea ) ;
    ExpLengthString = sprintf("Fiber Length (um): %s", FiberLength ) ;
    ExpBeamString = sprintf("Beam Stiffness (uN/um): %s", BeamStiffness) ;
    ExpDispString = sprintf("Forcing Displacement (um): %s", StrainDistance ) ;
    ExpDRString = sprintf("Forcing Rate (um/s): %s", StrainRate ) ;

    % Adding Fitting Details Text
    ExpYStressString = sprintf("Yield Stress (MPa): %.1f", YieldStress) ;
    ExpYStrainString = sprintf("Yield Strain: %.3f", YieldStrain) ;

    mu1String = sprintf("mu_1: %.1f", mu(1)) ;
    mu2String = sprintf("mu_2: %.1f", mu(2)) ;
    alpha1String = sprintf("alpha_1: %.3f", alpha(1) );
    alpha2String = sprintf("alpha_2: %.3f", alpha(2) );

    ExpErrorString1 = sprintf("R^2 = %.4f", Rsqrd) ;
    ExpErrorString2 = sprintf("RMSE = %.3f", RMSE) ;

    text(-0.15, 0.5, {ExpMaterialString, ExpSubString, ExpTDString, ExpCondString, ExpArrayString, ...
        ExpWSString,...
        ExpWPString, ExpFWHString, ExpSliceHatchString, ExpHatchStyleString, "", ...
        ExpBeamString, ExpDispString, ExpDRString, "", ExpAreaString, ExpLengthString, "", ...
        ExpYStressString, ExpYStrainString, "", mu1String, mu2String...
        alpha1String, alpha2String, ""...
        ExpErrorString1, ExpErrorString2},...
        'FontSize', 13, 'FontName', 'Arial') ;

    hold off ;

    pause(1) ;

end

