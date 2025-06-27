clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
% load('Average Stretch IP-S Fatigue Experiment.mat') ;
% load('Average Stretch IP-S Fatigue Table.mat') ;

load('Average Ogden Fatigue Experiments - v1.mat') ; 
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;

% Set Colors for Plotting
n_colors = 4; % Number of colors you want to sample
parula_colors = parula(n_colors);

% Apply the new color order
set(gca, 'ColorOrder', parula_colors, 'NextPlot', 'replacechildren');
co = get(gca, 'ColorOrder');
n_colors = size(co, 1);


i = 1 ;
for n = 1:size(AveragedStretchExps,1)

    FitParams = AveragedStretchExps{n,7} ;
    Yield = AveragedStretchExps{n,6}(:,2) ;
    mu = FitParams(:, [1 3]) ;
    alpha = FitParams(:, [2 4]) ;

    YSCell{1,n} = Yield ;

    mu1 = mu(:,1) ;
    mu1Cell{1,n} = mu1 ;

    mu2 = mu(:,2) ;
    mu2Cell{1,n} = mu2 ;

    alpha1Cell{1,n} = alpha(:,1) ;
    alpha2Cell{1,n} = alpha(:,2) ;

    CompData = AveragedStretchExps(n, [4 5]) ; 
    Stress = CompData{1, 1}(:,1) ;
    StressStd = CompData{1, 1}(:,2) ;
    Strain = CompData{1, 2}(:,1) ;

    XFill = [ Strain ; flip(Strain) ]  ;
    YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
    fill( XFill, YFill, co(mod(n-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.3); hold on;
    plothandles(n) = plot(Strain, Stress, 'color', co(mod(n-1, n_colors)+1, :), 'linewidth', 6) ; hold on ;

    MaxStressVals(n,1) = max(Stress) ;
    MaxStrainVals(n,1) = max(Strain) ;

end

FS = 18 ;

LegendString = ["Strain 1", "Strain 2", "Strain 3"] ; 
leg = legend(plothandles, LegendString,...
    'Location', 'northwest', 'FontSize', 15, 'box', 'on', 'LineWidth', 5, 'edgecolor', 'none') ;
%title(Details, 'FontSize', 15) ;
ylabel("Stress (MPa)") ;
xlabel("Strain") ;
ylim([0 140] ) ;
yticks(linspace(0,140,5)) ;
xlim([0 0.7]) ;
xticks(linspace(0,0.7,6))

ax = gca;
set(gca, 'FontSize', FS);  % Adjusted font size
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25;  % Increase the axis line width
ax.TickLength = [0.01 0.01];  % Increase the length of the tick marks
grid on;

TickLabels = {"1", "2", "3"} ;
PlotSavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Fatigue" ;

fullFilePath = fullfile(PlotSavePath, "Stress Strain Fatigue");

% Save the figure as a JPEG file
saveas(PlotFig, fullFilePath, 'tiff');
% pause(2) ;

% % Create the plot
fig1 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;
%customBoxPlot_noStats_ForPaper_v8(YSCell) ;
customBoxPlot_withStats_ForPaper_v8(YSCell) ;
ylim([38 80]) ;
yticks(linspace(40,80,5)) ;
set(gca, 'FontSize', FS) ;
ax = gca;
% ax.XAxis.FontSize = 11 ;  % Make x tick labels smaller
xticklabels(TickLabels);
ylabel('Stress (MPa)');
xlabel('Experiment Number', 'FontSize',FS) ;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig2 = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;
%customBoxPlot_noStats_ForPaper_v8(mu1Cell) ;
customBoxPlot_withStats_ForPaper_v8(mu1Cell) ;
ylim([750 1500]) ;
yticks(linspace(750,1500,4)) ;
set(gca, 'FontSize', FS) ;
ax = gca;
% ax.XAxis.FontSize = 11 ;  % Make x tick labels smaller
xticklabels(TickLabels);
ylabel('Modulus (MPa)');
xlabel('Experiment Number', 'FontSize',FS) ;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig3 = figure('units', 'inches', 'Position', [ 21.10,5.78125,5,4 ]); hold on;
%customBoxPlot_noStats_ForPaper_v8(mu2Cell) ;
customBoxPlot_withStats_ForPaper_v8(mu2Cell) ;
ylim([-700 -300]) ;
yticks(linspace(-700,-300,5)) ;
set(gca, 'FontSize', FS) ;
ax = gca;
% ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
xticklabels(TickLabels);
ylabel('Modulus (MPa)');
xlabel('Experiment Number', 'FontSize',FS) ;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig4 = figure('units', 'inches', 'Position', [ 16,0.76,5,4 ]); hold on;
%customBoxPlot_noStats_ForPaper_v8(alpha1Cell) ;
customBoxPlot_withStats_ForPaper_v8(alpha1Cell) ;
ylim([-26 -12]) ;
yticks(linspace(-26, -12, 8)) ;
set(gca, 'FontSize', FS) ;
ax = gca;
% ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
xticklabels(TickLabels);
ylabel('Strain Exponent');
xlabel('Experiment Number', 'FontSize',FS) ;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig5 = figure('units', 'inches', 'Position', [ 21.1,0.77,5,4 ]); hold on;
%customBoxPlot_noStats_ForPaper_v8(alpha2Cell) ;
customBoxPlot_withStats_ForPaper_v8(alpha2Cell) ;
ylim([7 15]) ;
yticks(linspace(7,15,5)) ;
set(gca, 'FontSize', FS) ;
ax = gca;
% ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
xticklabels(TickLabels);
ylabel('Strain Exponent');
xlabel('Experiment Number', 'FontSize',FS) ;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

% Define the directory where the figure will be saved
newFolder = 'Fatigue' ;

% Check if the folder exists, if not, create it
if ~exist(newFolder, 'dir')
    mkdir(newFolder);
end

fileName1 = n+"_YS"+'_Fig1_v1'+'.tiff';
fileName2 = n+"_mu1"+'_Fig2_v1'+'.tiff';
fileName3 = n+"_mu2"+'_Fig3_v1'+'.tiff';
fileName4 = n+"_alpha1"+'_Fig4_v1'+'.tiff';
fileName5 = n+"_alpha2"+'_Fig5_v1'+'.tiff';
path = cd ;
fullFilePath1 = fullfile(path, newFolder, fileName1);
fullFilePath2 = fullfile(path, newFolder, fileName2);
fullFilePath3 = fullfile(path, newFolder, fileName3);
fullFilePath4 = fullfile(path, newFolder, fileName4);
fullFilePath5 = fullfile(path, newFolder, fileName5);

% Save the figure as a JPEG file
saveas(fig1, fullFilePath1, 'tiff');
saveas(fig2, fullFilePath2, 'tiff');
saveas(fig3, fullFilePath3, 'tiff');
saveas(fig4, fullFilePath4, 'tiff');
saveas(fig5, fullFilePath5, 'tiff');

pause(1) ;
hold off ;

%close all ;
clear YSCell YStrainCell alpha2Cell alpha1Cell mu2Cell mu1Cell ;