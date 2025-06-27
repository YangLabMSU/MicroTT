clear ; clc ; close ;
% load data
load('Stretch Experiment Data Fit - Sub 6-5-24.mat') ;

% Plotting and Evaluating Data

% Set Up Figure
PlotFig = figure('Units', 'Normalized', 'Position', [0.25,0.15,0.36,0.675]) ;

for n = 1:size(StretchExperimentData)

    if string(StretchExperimentData{n,4}) ~= "Adjust Fit Style"

        Stress = StretchExperimentData{n,2} ;
        Strain = StretchExperimentData{n,3} ;

        % Load In Critical Data
        CriticalPts = StretchExperimentData{n,4} ;
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
        StrainFit = Strain ;
        StressFit = E1.*StrainFit - E2*exp(-(Lam1./StrainFit)) - E3*exp(-(Lam2./StrainFit)) ;

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
        legend('Location', 'north') ;
        legend('boxoff') ; box off; grid on; ax = gca ;
        set(ax, 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'bold',...
            'LineWidth', 1.5, 'TickLength', [ 0.015, 0.2 ]);

        % Adding Experiment Details Text
        ExpMaterialString = sprintf("Material: %s", Materials) ;
        ExpSubString = sprintf("Substrate: %s", Substrate ) ;
        ExpTDString = sprintf("Test Date: %s", TestDate) ;
        ExpCondString = sprintf("Conditions: %s", Conditions ) ;
        ExpWSString = sprintf("Writing Speed (mm/s): %s", WriteSpeed ) ;
        ExpWPString = sprintf("Writing Power (mW): %0.2f", Power ) ;
        ExpFWHString = sprintf("Fiber Design Width x Height (um): %s x %s", FWidth, FHeight) ;
        ExpSliceHatchString = sprintf("Fiber Slice x Hatch (um), and Angle: %s x %s, %s", ...
            Slice, Hatch, Style) ;
        ExpAreaString = sprintf("Fiber Area (um^2): %s", SEMArea ) ;
        ExpLengthString = sprintf("Fiber Length (um): %s", FiberLength ) ;
        ExpDispString = sprintf("Forcing Displacement (um): %s", StrainDistance ) ;
        ExpDRString = sprintf("Forcing Rate (um/s): %s", StrainRate ) ;

        TPX1 = 0.05 ; %Strain(end) / 2 ;
        TPX2 = Strain(end) / 2 ;
        TPY1 = Stress(end) - (Stress(end)/5) ;
        TPY2 = YieldStress ;

        text(TPX1, TPY1, {ExpMaterialString, ExpSubString, ExpTDString, ExpCondString, ExpWSString,...
            ExpWPString, ExpFWHString, ExpSliceHatchString, ExpAreaString, ...
            ExpDispString, ExpDRString, ExpAreaString, ExpLengthString},...
            'FontSize', 13, 'FontName', 'Arial') ;

        % Adding Fitting Details Text
        ExpYPString = sprintf("Yield Stress (MPa) & Strain: %.1f & %.3f", YieldStress, YieldStrain ) ;
        ExpModString = sprintf("Youngs, 2nd, & 3rd Modulus: %.1f, %.1f, %.1f", E1, E2, E3 ) ;
        ExpStrainCoeffString = sprintf("1st & 2nd Strain Coeffs: %.3f, %.3f", Lam1, Lam2 );
        ExpErrorString1 = sprintf("R^2 = %.4f", Rsqrd) ;
        ExpErrorString2 = sprintf("RMSE = %.3f", RMSE) ;

        text(TPX2, TPY2 , {ExpYPString, ExpModString, ExpStrainCoeffString, ...
            ExpErrorString1, ExpErrorString2},...
            'FontSize', 13, 'FontName', 'Arial') ;

        % Titles and Axes Lables
        title('TPPTT Curve Fitting') ;
        xlabel('Strain') ;
        ylabel('Stress (uN/um^2)') ;


        % Saving
        parts = split(Substrate, '/');  % Split the string by hyphens
        month = parts{1};
        day = parts{2};
        year = parts{3};  % Assuming the year is in the 21st century
        SubSave = month + "-" + day + "-" + year;

        parts = split(TestDate, '/');  % Split the string by hyphens
        month = parts{1};
        day = parts{2};
        year = parts{3};  % Assuming the year is in the 21st century
        TDSave = month + "-" + day + "-" + year;

        % Save in Folder, and Save in a All Experiment Folder
        figname = sprintf("%s_%s_%s_%s", Materials, SubSave, TDSave, ArrayPosition) ;

        % Define the directory where the figure will be saved
        newFolder = 'Fitting Summaries' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        fileName = figname+'.tiff'; 

        % Local Path
        path = cd ;
        fullFilePath = fullfile(path, newFolder, fileName);

        % Save the figure as a JPEG file
        saveas(PlotFig, fullFilePath, 'tiff');

        % Folder Path
        FolderPath = Parameters(27) ; 
        parts = split(FolderPath, '\') ;
        path = strjoin(parts(1:end-1),'\') ;
        fileName = "CurveFitFig" ; 
        fullFilePath = fullfile(path, fileName);

        % Save the figure as a JPEG file
        saveas(PlotFig, fullFilePath, 'tiff');

        hold off ; 
    end

end
