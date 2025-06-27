clear ; clc ; close all ;

% Plotting and Comparing the Entire Datasets of all IP-S, IP-Visio, and IP-Dip
load('IP-Dip Fit Values for Comparison.mat') ;

YSCell{1,1} = IPDipFitValues(:,7) ;
Mods1Cell{1,1} = IPDipFitValues(:,1) ;
Mods2Cell{1,1} = IPDipFitValues(:,2) ;
Mods3Cell{1,1} = IPDipFitValues(:,4) ;
Lam1Cell{1,1} = IPDipFitValues(:,3) ;
Lam2Cell{1,1} = IPDipFitValues(:,5) ;


%TickLabels = {"IP-S", "IP-Visio", "IP-Dip"} ; 

% Create the plot
fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
%fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
customBoxPlot_v3(YSCell) ;
%xlim([0.5 3.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels("Yield Strength") ;
ylabel('Stress (MPa)', 'FontSize', 14);
title('Yield Stress', 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'FontSize', 14) ;
title("Yield Stress, \sigma_y", 'FontSize',12)
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig2 = figure('units', 'inches', 'Position', [ 13.5, 0.5, 12, 3 ]); hold on;
subplot(1,3,1) ;
customBoxPlot_v3(Mods1Cell) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels("E_1");
ylabel('Moduli (MPa)', 'FontSize', 14);
set(gca, 'FontSize', 14) ;
title("Youngs Modulus, 1st Modulus E_1", 'FontSize',12) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

subplot(1,3,2) ;
%fig3 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
customBoxPlot_v3(Mods2Cell) ;
%xlim([0.5 3.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels("E_2");
% ylabel('Moduli (MPa)', 'FontSize', 14);
% title('Moduli');
set(gca, 'FontSize', 14) ;
title("2nd Modulus E_2", 'FontSize',12) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

subplot(1,3,3) ;
%fig4 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
customBoxPlot_v3(Mods3Cell) ;
%xlim([0.5 3.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels("E_3");
set(gca, 'FontSize', 14) ;
title("3rd Modulus E_3", 'FontSize',12) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fig3 = figure('units', 'inches', 'Position', [ 13.5, 5, 8, 3 ]); hold on;
subplot(1,2,1) ; 
customBoxPlot_v3(Lam1Cell) ; hold on ; 
%xlim([0.5 3.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
xticklabels("\lambda_1");
ylabel('Strain Coefficient', 'FontSize', 14);
%title('Strain Coefficient');
set(gca, 'FontSize', 14) ;
title("Strain Coefficient 1, \lambda_1", 'FontSize',12)
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

subplot(1, 2, 2) ;
%fig6 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
customBoxPlot_v3(Lam2Cell) ; hold on ; 
%xlim([0.5 3.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
xticklabels("\lambda_2");
set(gca, 'FontSize', 14) ;
title("Strain Coefficient 2, \lambda_2", 'FontSize',12)
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

% Define the directory where the figure will be saved
newFolder = 'Dissertation - IPDip Evaluation' ;

% Check if the folder exists, if not, create it
if ~exist(newFolder, 'dir')
    mkdir(newFolder);
end

Details2 = "IPVisio_" ; 
fileName1 = Details2+'_Yield_v2'+'.tiff';
fileName2 = Details2+'_Moudli_v2'+'.tiff';
fileName3 = Details2+'_Strain_v2'+'.tiff';

path = cd ;
fullFilePath1 = fullfile(path, newFolder, fileName1);
fullFilePath2 = fullfile(path, newFolder, fileName2);
fullFilePath3 = fullfile(path, newFolder, fileName3);

% Save the figure as a JPEG file
saveas(fig1, fullFilePath1, 'tiff');
saveas(fig2, fullFilePath2, 'tiff');
saveas(fig3, fullFilePath3, 'tiff');


pause(1) ;
hold off ;