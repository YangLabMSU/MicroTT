clear ; clc ; close all ;
% Plotting Elastic Experiment for Paper

ElasticPath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23\34" ; % \Processed Data.mat" ;
ElasticData = load(fullfile(ElasticPath, "Processed Data.mat"));
ElasticFit = load(fullfile(ElasticPath, "Fit Data.mat"));
SavePath = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 6 - Cyclic Testing" ;

% Extract necessary data
FitTimes = ElasticFit.FitData.Stress.Trtime;
ElasticTime = ElasticData.ProcessedData.Time;
ElasticStress = ElasticData.ProcessedData.Stress-ElasticData.ProcessedData.Stress(1);
ElasticPlateStrain = ElasticData.ProcessedData.PlateStrain-ElasticData.ProcessedData.PlateStrain(1);
ElasticFiberStrain = ElasticData.ProcessedData.FiberStrain-ElasticData.ProcessedData.FiberStrain(1);

% Find indices for the troughs
TrIdx = zeros(size(FitTimes, 1), 1);
for n = 1:size(FitTimes, 1)
    TrIdx(n,1) = find(ElasticTime >= FitTimes(n), 1, "first");
end

% Add the last index for the full range
TrIdx = [TrIdx; length(ElasticTime)];

% Set up figure
% MedPlotSize = [10, 5, 5*4, 3.5*4];
MedPlotSize = [10, 5, 7.1*3, 4.8*3];
fig1 = figure('units', 'centimeters', 'position', MedPlotSize);
hold on;

% Set colormap for gradient
cmap = turbo(length(TrIdx) - 1); % Adjust the number of colors to match cycles
colormap(turbo(length(TrIdx) - 1));

% Plot each segment with a unique color
for i = 0:length(TrIdx)-1
    if i == 0

        % Segment data for each cycle
        segmentStress = ElasticStress(1:TrIdx(1));
        segmentFiberStrain = ElasticFiberStrain(1:TrIdx(1));

        % Plot for Fiber Strain
        plot(smooth(segmentFiberStrain), segmentStress, 'Color', cmap(1, :), 'LineWidth', 4, 'DisplayName', sprintf('Cycle %d (Fiber)', i));

    else

        % Segment data for each cycle
        segmentStress = ElasticStress(TrIdx(i):TrIdx(i+1)-1);
        segmentFiberStrain = ElasticFiberStrain(TrIdx(i):TrIdx(i+1)-1);

        % Plot for Fiber Strain
        plot(smooth(segmentFiberStrain), segmentStress, 'Color', cmap(i, :), 'LineWidth', 4, 'DisplayName', sprintf('Cycle %d (Fiber)', i));

    end
end

% Customize plot
ylabel("Stress (MPa)");
xlabel("Strain");
% xtickformat('%.3f');
xlim([-0.002 0.015]) ; 
set(gca, 'FontSize', 20);
ax = gca;
ax.XAxis.Exponent = 0; % Disable scientific notation on the x-axis
ax.XTickLabel = arrayfun(@(x) sprintf('%.3f', x), ax.XTick, 'UniformOutput', false); % Set tick labels
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.5; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on;
% legend show; % Display legend
% Adjust colorbar to map to number of cycles
% cbar = colorbar; % Get the colorbar handle
% cbar.Ticks = linspace(0, 1, 5); % Set ticks based on the number of cycles
% cbar.TickLabels = linspace(0, length(TrIdx), 5) ; % Label the ticks from 0 to the number of cycles (60)
% cbar.Label.String = 'Strain Cycle'; % Add label to the colorbar
% cbar.Label.FontSize = 14 ;
% cbar.FontSize = 14 ; 
% cbar.Label.FontSize = 18 ;
% title('Stress-Strain Curve with Cycle Color Gradient');

fileName6 = 'Elastic_StressStrain_v4';
filename6 = fullfile(SavePath,fileName6);  % Set your desired file name
print(filename6, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
