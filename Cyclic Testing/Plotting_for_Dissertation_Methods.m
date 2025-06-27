clear ; clc ; close all ;

% Plot Storage and Loss Moduli Data

% Generate Data Directory
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;
% folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
% DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;
% DataDirectory2 = LoadRawDataExperimentDirectory_Folder(folderpath) ;
% DataDirectory = [ DataDirectory1 ; DataDirectory2 ] ;

i = 1;
for n = 10 %:size(DataDirectory)

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

    [PlotFig1, PlotFig2] = Stress_Strain_Cylic_Plotting(time, stress, fiberstrain, platestrain) ;

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

    [PlotFig3] = Stress_and_Fiber_Strain_Plotting(StressPktime, StressPk, FibStrainPktime, FibStrainPk, FibStrainTrtime, FibStrainTr) ;

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
    yLimits = ylim ;
    ylim([yLimits(1)-yLimits(1)*0.2 yLimits(2)+yLimits(2)*0.2]) ; 
    yticks(round(linspace(yLimits(1)+0.0005, yLimits(2)-0.0005, 4),3)) ;
    xlim([ 1 StrainCycle(end)+2 ]) ; 
    xLimits = xlim ;
    xticks(round(linspace(StrainCycle(1),StrainCycle(end),6))) ;
    ylabel('Hysteresis Area (MPa)', 'FontSize', 14);
    xlabel("Strain Cycle", "FontSize", 14) ;

    % % Get Path
    % Name = strsplit(loadpath, "\") ; 
    % Name = Name(end) ; 
    % %SavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Cyclic Testing\All Plots\Substrate 9-05-23_TD 10-18-23" ; 
    % SavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Cyclic Testing\All Plots\Substrate 10-27-23_TD 11-15-23" ; 
    % DataDir = fullfile(SavePath, Name) ;
    % if ~exist(DataDir, 'dir')
    %     mkdir(DataDir);
    % end
    % 
    % filename1 = fullfile(DataDir, 'Time Plots.tiff');
    % filename2 = fullfile(DataDir, 'Stress Strain.tiff');
    % filename3 = fullfile(DataDir, 'Peak Evaluation.tiff');
    % filename4 = fullfile(DataDir, 'Hysteresis.tiff');
    % print(PlotFig1, '-dtiff', '-r300', filename1);
    % print(PlotFig2, '-dtiff', '-r300', filename2);
    % print(PlotFig3, '-dtiff', '-r300', filename3);
    % print(PlotFig4, '-dtiff', '-r300', filename4); 
    % pause(0.25) ; 

    % clear Hysteresis ; close all ; 
end




