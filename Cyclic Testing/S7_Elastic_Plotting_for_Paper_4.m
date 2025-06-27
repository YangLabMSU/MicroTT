clear; clc; close all;

% Generate Data Directory
Path = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23\34";
Data = load(fullfile(Path, "Processed Data.mat"));
Fit = load(fullfile(Path, "Fit Data.mat"));
SavePath = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 6 - Cyclic Testing";

% Extract necessary data
FitTrTimes = Fit.FitData.Stress.Trtime;
FitPkTimes = Fit.FitData.Stress.Pktime;
Time = Data.ProcessedData.Time;
Stress = Data.ProcessedData.Stress - Data.ProcessedData.Stress(1);
PlateStrain = Data.ProcessedData.PlateStrain - Data.ProcessedData.PlateStrain(1);
FiberStrain = Data.ProcessedData.FiberStrain - Data.ProcessedData.FiberStrain(1);

% Find indices for the peaks
PkIdx = zeros(size(FitPkTimes, 1), 1);
for n = 1:size(FitPkTimes, 1)
    PkIdx(n) = find(Time >= FitPkTimes(n), 1, "first");
end

% Add the last index for the full range
PkIdx = [PkIdx; length(Time)];

% Find indices for the troughs
TrIdx = zeros(size(FitTrTimes, 1), 1);
for n = 1:size(FitTrTimes, 1)
    TrIdx(n) = find(Time >= FitTrTimes(n), 1, "first");
end

% Add the last index for the full range
TrIdx = [TrIdx; length(Time)];

% Evaluate the Stress-Strain Curves of each cycle
Hysteresis = zeros(size(FitPkTimes, 1) - 2, 1); % Preallocate Hysteresis array
for n = 2:size(FitPkTimes, 1)
    % Define indices for unloading and loading
    UnLoadIdxStart = PkIdx(n-1);
    MidIdx = TrIdx(n-1);
    LoadIdxEnd = PkIdx(n);

    % Extract unloading and loading stress and strain data
    UnloadStress = Stress(UnLoadIdxStart:MidIdx);
    LoadStress = Stress(MidIdx:LoadIdxEnd);
    FiberStrainUnload = FiberStrain(UnLoadIdxStart:MidIdx);
    FiberStrainLoad = FiberStrain(MidIdx:LoadIdxEnd);

    % Calculate the areas using the trapezoidal rule
    UnLoadingArea = trapz(flipud(FiberStrainUnload), flipud(UnloadStress));
    LoadingArea = trapz(FiberStrainLoad, LoadStress);
    Hysteresis(n-1) = LoadingArea - UnLoadingArea; % Calculate hysteresis area
end

StrainCycle = 2:size(Hysteresis, 1) + 1;

% Plot Hysteresis Area vs Cycles
% MedPlotSize = [10, 5, 4.1*4, 1.75*4];
MedPlotSize = [10, 5, 7.1*3, 3.4*3];

fig1 = figure('units', 'centimeters', 'position', MedPlotSize);
hold on;

plot(StrainCycle, smooth(Hysteresis,2), '-.', 'linewidth', 3, 'Color', "#848494") ; %"#bfbfc7");

% Define colormap to match cycling colors
cmap = turbo(size(Hysteresis, 1)); % Use same colormap as the stress-strain plot
colormap(cmap);

% Plot Hysteresis Area vs Cycles with cycle-matched colors
% StrainCycle = 2:size(Hysteresis, 1) + 1;
hold on;
for i = 1:length(Hysteresis)
    plot(StrainCycle(i), Hysteresis(i), 'o', 'Color', 'k', 'LineWidth', 1, 'MarkerSize', 12, 'MarkerFaceColor', cmap(i, :));
end

set(gca, 'FontSize', 20);
ax = gca;
ax.Box = 'on';
set(ax, 'BoxStyle', 'full');
ax.LineWidth = 1.25;
ax.TickLength = [0.01 0.01];
grid on;
ylim([-0.5, 0.5]);
yticks(linspace(-0.5, 0.5, 5));
xlim([0, StrainCycle(end) + 2]);
% xticks(round(linspace(2, StrainCycle(end), 10)));
ylabel({'Hysteresis Area'; '(MPa)'});
xlabel("Strain Cycle");

% Save the figure
fileName = 'Elastic_Hysteresis_Area_vs_Cycles_v2';
filename = fullfile(SavePath, fileName);
print(filename, '-djpeg', '-r300'); % Save as JPEG with 300 dpi resolution
