clear ; clc ; close all ;

% Plotting and Comparing the Entire Datasets of all IP-S, IP-Visio, and IP-Dip

load('IP-Dip Fit Values for Comparison.mat') ;
load('IP-S Fit Values for Comparison - v2.mat') ;
load('IP-Visio Fit Values for Comparison.mat') ;

YSCell{1,1} = IPSFitValues(:,7) ;
YSCell{1,3} = IPVisioFitValues(:,7) ;
YSCell{1,2} = IPDipFitValues(:,7) ;

Mods1Cell{1,1} = IPSFitValues(:,1) ;
Mods1Cell{1,3} = IPVisioFitValues(:,1) ;
Mods1Cell{1,2} = IPDipFitValues(:,1) ;

Mods2Cell{1,1} = IPSFitValues(:,2) ./ IPSFitValues(:,1) ;
Mods2Cell{1,3} = IPVisioFitValues(:,2) ./ IPVisioFitValues(:,1);
Mods2Cell{1,2} = IPDipFitValues(:,2) ./ IPDipFitValues(:,1) ;

Mods3Cell{1,1} = IPSFitValues(:,4) ./ IPSFitValues(:,1) ;
Mods3Cell{1,3} = IPVisioFitValues(:,4) ./ IPVisioFitValues(:,1);
Mods3Cell{1,2} = IPDipFitValues(:,4) ./ IPDipFitValues(:,1) ;

Lam1Cell{1,1} = IPSFitValues(:,3) ;
Lam1Cell{1,3} = IPVisioFitValues(:,3) ;
Lam1Cell{1,2} = IPDipFitValues(:,3) ;

Lam2Cell{1,1} = IPSFitValues(:,5) ;
Lam2Cell{1,3} = IPVisioFitValues(:,5) ;
Lam2Cell{1,2} = IPDipFitValues(:,5) ;

TickLabels = {"IP-S", "IP-Dip", "IP-Visio"} ;



% path = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\All Materials" ;
% PlotSize1 = [15, 5, 5.3*3, 3*3] ;
% PlotSize2 = [15, 5, 2.65*3, 3*3] ;
% TitleFontSize = 18 ;
% TextFontSize = 20 ;
% 
% % Create the plot
% fig1 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4] ); hold on ;
% customBoxPlot_withStats_v12(YSCell) ;
% ylim([0 112]) ;
% yticks(linspace(0, 100, 5)) ;
% xlim([0.5 3.75]) ;
% xticklabels(TickLabels);
% ylabel('Stress (MPa)', 'FontSize', 14);
% set(gca, 'FontSize', TextFontSize) ;
% ax = gca;
% ax.Box = 'on';  % Turn on the box
% set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
% ax.LineWidth = 1.25 ; % Increase the axis line width
% ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
% grid on ;
% 
% fileName1 = 'Pow_YS_v1';
% filename1 = fullfile(path,fileName1);  % Set your desired file name
% print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
% 
% fig2 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4] ); hold on ;
% customBoxPlot_withStats_v12(Mods1Cell) ;
% ylim([0 2700]) ;
% yticks(linspace(0,2000,5)) ;
% xticklabels(TickLabels);
% xlim([0.5 3.75]) ;
% ylabel('Moduli (MPa)', 'FontSize', 14);
% set(gca, 'FontSize', TextFontSize) ;
% ax = gca;
% ax.Box = 'on';  % Turn on the box
% set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
% ax.LineWidth = 1.25 ; % Increase the axis line width
% ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
% grid on ;
% 
% fileName2 = 'Pow_YM_v1';
% filename2 = fullfile(path,fileName2);  % Set your desired file name
% print(filename2, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
