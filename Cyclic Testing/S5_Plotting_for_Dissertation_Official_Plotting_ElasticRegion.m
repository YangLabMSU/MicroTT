clear ; clc ; close all ;

% Plot Storage and Loss Moduli Data

% Generate Data Directory
% folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;
% DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;
% DataDirectory2 = LoadRawDataExperimentDirectory_Folder(folderpath) ;
% DataDirectory = [ DataDirectory1 ; DataDirectory2 ] ;

i = 1;
for n = 4 %1:size(DataDirectory)

    % Get Path
    loadpath = DataDirectory(n,1);

    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat");
    load(DataPath);

    % Load your data (replace with actual data loading method)
    stress = ProcessedData.Stress;
    fiberstrain = ProcessedData.FiberStrain;
    platestrain = ProcessedData.PlateStrain;
    time = ProcessedData.Time;

    %[PlotFig1, PlotFig2] = Stress_Strain_Cylic_Plotting(time, stress, fiberstrain, platestrain) ;

    % Plot the original data points and the fitted sine wave
    PlotFig1 = figure('Units', 'inches', 'Position', [10,5,6.5,5]);
    subplot(2,1,1) ;
    plot(time, stress, 'linewidth', 3); hold on;

    set(gca, 'FontSize', 14) ;
    title("Stress",'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    ylim([min(stress)*1.2 max(stress)*1.2])
    yLimits = ylim ;
    yticks(round(linspace(0, yLimits(2)-1, 5))) ;
    xlim([0 max(time)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Stress (MPa)', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;


    subplot(2,1,2) ;
    plot(time, platestrain, 'linewidth', 3); hold on;
    plot(time, fiberstrain, 'linewidth', 3);

    set(gca, 'FontSize', 14) ;
    title("Strain", 'FontSize',12) ;
    legend('Plate Strain', 'Fiber Strain', 'location', 'north', 'box', 'off', 'fontsize',9);
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    ylim([min(platestrain)*1.2 max(fiberstrain)*1.6]) ;
    yLimits = ylim ;
    yticks(round(linspace(0, yLimits(2)-yLimits(2)*0.01, 5),3)) ;
    xlim([0 max(time)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Strain', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;


    PlotFig2 = figure('Units', 'inches', 'Position', [3.4375,6,6.5,4]);
    plot(platestrain, stress, 'linewidth', 4) ; hold on ;
    plot(fiberstrain, stress, 'Linewidth', 2) ;
    yLimits = ylim ;
    yticks(round(linspace(0,yLimits(2)-1,6))) ;
    xLimits = xlim ;
    xticks(round(linspace(0, xLimits(2)-xLimits(2)*.1, 6),4)) ;
    ylabel('Moduli (MPa)', 'FontSize', 14);
    xlabel("Strain", "FontSize", 14) ;
    set(gca, 'FontSize', 14) ;
    title("Stress-Strain Curve", 'FontSize',12) ;
    legend('Plate Strain', 'Fiber Strain', 'location', 'northwest', 'box', 'off');
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;


    % Next to Analyze the peaks in details

    % Load in Fit Data
    FitPath = fullfile(DataDirectory(n,1), "Fit Data.mat");
    load(FitPath);

    StressPk = FitData.Stress.Pk ;
    StressPktime = FitData.Stress.Pktime ;
    StressTr = FitData.Stress.Tr ;
    StressTrTime = FitData.Stress.Trtime ;

    FibStrainPk = FitData.Fiber.Pk ;
    FibStrainPktime = FitData.Fiber.Pktime ;
    FibStrainTr = FitData.Fiber.Tr ;
    FibStrainTrtime = FitData.Fiber.Trtime ;

    PlateStrainPk = FitData.Plate.Pk ;
    PlateStrainPktime = FitData.Plate.Pktime ;

    %[PlotFig3] = Stress_and_Fiber_Strain_Plotting(StressPktime, StressPk, FibStrainPktime, FibStrainPk, FibStrainTrtime, FibStrainTr) ;

    % Plot the original data points and the fitted sine wave
    PlotFig3 = figure('Units', 'inches', 'Position', [16.5,4,5.25,6]);
    subplot(3,1,1) ;
    plot(StressPktime, StressPk, '-x', 'linewidth', 3); hold on;
    set(gca, 'FontSize', 14) ;
    title("Stress Peaks", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    ylim([21 24]) ; 
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1), yLimits(2), 4),1)) ;
    xlim([0 max(StressPktime)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Stress (MPa)', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;

    subplot(3,1,2) ;
    %%
    yyaxis left ;
    plot(FibStrainPktime, FibStrainPk, '-x', 'linewidth', 3); hold on;
    %plot(FibStrainTrtime, FibStrainTr, '-x', 'linewidth', 3);
    set(gca, 'FontSize', 14) ;
    title("Fiber Strain Peaks and Troughs", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    ylim([0.010 0.015])
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1), yLimits(2), 4),4)) ;
    xlim([0 max(FibStrainPktime)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Strain', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;

    yyaxis right ;
    plot(FibStrainTrtime, FibStrainTr, '-x', 'linewidth', 3);
    ylim([-0.0005, 0.0045])
    yLimits = ylim ;
    % yLimits = ylim ;
    yticks(round(linspace(yLimits(1), yLimits(2), 4),5)) ;
    leg = legend("Peaks", "Troughs", 'Location', 'north', 'fontsize', 8, 'box', 'off') ;
    leg.NumColumns = 2; 

    %%

    subplot(3,1,3) ;
    FibStrainDiff = FibStrainPk(1:size(FibStrainTr,1)) - FibStrainTr ;
    plot(FibStrainDiff, '-x', 'linewidth', 3);
    set(gca, 'FontSize', 14) ;
    title("Fiber Strain Difference", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on
    ylim([0.008 0.014]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1), yLimits(2), 4),4)) ;
    xLimits = xlim ;
    xticks(round(linspace(1,xLimits(2),6))) ;
    ylabel('Strain Difference', 'FontSize', 14);
    xlabel("Strain Cycle", "FontSize", 14) ;

    %%

    % Next, Analyzing the Hysteresis Cylces

    % Determine the Indices of all the stress peaks, and their associated Timings
    for n = 1:size(StressPktime,1)

        TimePoint = StressPktime(n) ;
        TimePkIdx(n) = find( time >= TimePoint, 1, "first" ) ;

    end

    % Determine the Indices of all the strain troughs, and their associated Timings
    for n = 1:size(StressTrTime,1)

        TimePoint = StressTrTime(n) ;
        TimeTrIdx(n) = find( time >= TimePoint, 1, "first" ) ;

    end

    % Evaluate the Stress Strain Curves of that time.
    for n = 3:size(StressPktime)

        % Define indices for unloading and loading
        UnLoadIdxStart = TimePkIdx(n-1);
        MidIdx = TimeTrIdx(n-1);
        LoadIdxEnd = TimePkIdx(n);

        % Extract unloading and loading stress and strain data
        UnloadStress = stress(UnLoadIdxStart:MidIdx);
        LoadStress = stress(MidIdx:LoadIdxEnd);
        FiberStrainUnload = fiberstrain(UnLoadIdxStart:MidIdx);
        FiberStrainLoad = fiberstrain(MidIdx:LoadIdxEnd);

        % Calculate the areas using trapezoidal rule
        UnLoadingArea = trapz(flipud(FiberStrainUnload), flipud(UnloadStress));
        LoadingArea = trapz(FiberStrainLoad, LoadStress);
        Hysteresis(n-2) = LoadingArea - UnLoadingArea ;
        %disp(Hysteresis(n-2) + " J/m^3") ;

        % % Plot unloading and loading curves
        % plot(FiberStrainUnload, UnloadStress, 'linewidth', 2); hold on ;
        % plot(FiberStrainLoad, LoadStress, 'linewidth', 2);
        %
        % % Fill the area between the loading and unloading curves
        % fill([FiberStrainUnload ; FiberStrainLoad], [UnloadStress ; LoadStress ], 'r', 'FaceAlpha', 0.3);
        % pause(0.5) ; hold off ;

    end

    PlotFig4 = figure('Units', 'inches', 'Position', [4.6,2.1,5.25,3]);
    StrainCycle = 3:size(Hysteresis,2)+2 ;
    plot(StrainCycle, Hysteresis, '-x', 'linewidth', 3);
    set(gca, 'FontSize', 14) ;
    title("Hysteresis Area vs Cycles", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on
    ylim([-0.08, 0.08])
    yLimits = ylim ;
    ylim([yLimits(1) yLimits(2)]) ;
    yticks(round(linspace(yLimits(1), yLimits(2),5),3)) ;
    xlim([ 1 StrainCycle(end)+2 ]) ;
    xLimits = xlim ;
    xticks(round(linspace(StrainCycle(1),StrainCycle(end),6))) ;
    ylabel('Hysteresis Area (MPa)', 'FontSize', 14);
    xlabel("Strain Cycle", "FontSize", 14) ;


    % Get Path
    Name = strsplit(loadpath, "\") ;
    Name = Name(end) ;
    %SavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Cyclic Testing\All Plots\Substrate 9-05-23_TD 10-18-23" ;
    SavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Cyclic Testing\All Plots\Substrate 10-27-23_TD 11-15-23" ;
    DataDir = fullfile(SavePath, Name) ;
    if ~exist(DataDir, 'dir')
        mkdir(DataDir);
    end

    filename1 = fullfile(DataDir, 'Time Plots.tiff');
    filename2 = fullfile(DataDir, 'Stress Strain.tiff');
    filename3 = fullfile(DataDir, 'Peak Evaluation.tiff');
    filename4 = fullfile(DataDir, 'Hysteresis.tiff');
    print(PlotFig1, '-dtiff', '-r300', filename1);
    print(PlotFig2, '-dtiff', '-r300', filename2);
    print(PlotFig3, '-dtiff', '-r300', filename3);
    print(PlotFig4, '-dtiff', '-r300', filename4);
    pause(0.25) ;

    clear Hysteresis ; close all ;

end




