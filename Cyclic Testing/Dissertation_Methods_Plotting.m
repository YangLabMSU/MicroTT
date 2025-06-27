clear ; clc ; close ;

% Plotting for Dissertation Methods

folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

n = 10 ;

% Get Path
loadpath = DataDirectory(n,1);

% Load in Data and Parameters
DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat");
load(DataPath);

% Load in Fit Data
FitPath = fullfile(DataDirectory(n,1), "Fit Data.mat");
load(FitPath);

% Load your data (replace with actual data loading method)
stress = ProcessedData.Stress(1:2500);
fiberstrain = ProcessedData.FiberStrain(1:2500);
platestrain = ProcessedData.PlateStrain(1:2500);
time = ProcessedData.Time(1:2500);

% Plot Stress, Strain, and Peaks
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
PlateStrainTr = FitData.Plate.Tr ;
PlateStrainTrtime = FitData.Plate.Trtime ;

% %%%%% Plotting Template %%%%%

% Stress
PlotFig0 = figure('units','inches','Position',[2,2,6,7.25]) ;
subplot(3,1,1) ;
plot(time, stress, '-b', 'linewidth', 3); hold on;
plot(StressPktime, StressPk, '+c', 'linewidth', 2);
plot(StressTrTime, StressTr, 'og', 'linewidth', 2);
set(gca, 'FontSize', 14) ;
title("Stress", 'FontSize',12) ;
legend('Stress', 'Peaks', 'Troughs', 'location', 'northeast', 'box', 'off', 'fontsize',9);
ylabel('Stress');
xlabel("Time (s)") ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1), yLimits(2), 5))) ;
xLimits = xlim ;
xlim([0 xLimits(2)*1.25])
xLimits = xlim ;
xticks(round(linspace(0,xLimits(2),6))) ;


% Fiber Strain
%PlotFig1 = figure() ;
subplot(3,1,2) ;
plot(time, fiberstrain, '-b', 'linewidth', 3); hold on;
plot(FibStrainPktime, FibStrainPk, '+c', 'linewidth', 2);
plot(FibStrainTrtime, FibStrainTr, 'og', 'linewidth', 2);
set(gca, 'FontSize', 14) ;
title("Fiber Strain", 'FontSize',12) ;
legend('Fiber Strain', 'Peaks', 'Troughs', 'location', 'southeast', 'box', 'off', 'fontsize',9);
ylabel('Strain');
xlabel("Time (s)") ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1), yLimits(2), 5),3)) ;
xLimits = xlim ;
xlim([0 xLimits(2)*1.25])
xLimits = xlim ;
xticks(round(linspace(0,xLimits(2),6))) ;

% Plate Strain
% PlotFig2 = figure() ;
subplot(3,1,3) ;
plot(time, platestrain, '-b', 'linewidth', 3); hold on;
plot(PlateStrainPktime, PlateStrainPk, '+c', 'linewidth', 2);
plot(PlateStrainTrtime, PlateStrainTr, 'og', 'linewidth', 2);
set(gca, 'FontSize', 14) ;
title("Plate Strain", 'FontSize',12) ;
legend('Plate Strain', 'Peaks', 'Troughs', 'location', 'northeast', 'box', 'off', 'fontsize',9);
ylabel('Strain');
xlabel("Time (s)") ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1), yLimits(2), 5),3)) ;
xLimits = xlim ;
xlim([0 xLimits(2)*1.25])
xLimits = xlim ;
xticks(round(linspace(0,xLimits(2),6))) ;

% Plot Stress-Strain Curves
PlotFig1 = figure('units','inches','Position',[2,2,6,3.5]) ;
plot(fiberstrain, stress, '-b', 'linewidth', 3); hold on;
set(gca, 'FontSize', 14) ;
title("Stress-Fiber Strain", 'FontSize',12) ;
ylabel('Stress (MPa)');
xlabel("Strain") ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1), yLimits(2), 5))) ;
xLimits = xlim ;
xticks(round(linspace(0,xLimits(2),6),3)) ;


% Stress Strain Hysteresis Evaluation

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
PlotFig2 = figure('units','inches','Position',[2,2,6,3.5]) ;
for n = 3 %:size(StressPktime)

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
    disp(Hysteresis(n-2) + " J/m^3") ;

    % Plot unloading and loading curves
    plot(FiberStrainUnload, UnloadStress, 'linewidth', 3); hold on ;
    plot(FiberStrainLoad, LoadStress, 'linewidth', 3);

    % Fill the area between the loading and unloading curves
    fill([FiberStrainUnload ; FiberStrainLoad], [UnloadStress ; LoadStress ], 'r', 'FaceAlpha', 0.3);
    legend("Unloading", "Loading", "Hysteresis Area", 'Location', 'northwest', 'box', 'off', 'fontsize', 12) ;
    pause(0.5) ; hold off ;
    set(gca, 'FontSize', 14) ;
    title("Stress-Fiber Strain Hysteresis", 'FontSize',12) ;
    ylabel('Stress (MPa)');
    xlabel("Strain") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1), yLimits(2), 5))) ;
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2),6),3)) ;
    text(0.28, 15, "Area Calculation: " + Hysteresis(n-2) + " MPa", 'fontsize', 11) ; 


end
