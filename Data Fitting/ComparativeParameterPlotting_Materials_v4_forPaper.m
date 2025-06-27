clear ; clc ; close all ;

% Plotting and Comparing the Entire Datasets of all IP-S, IP-Visio, and IP-Dip

load('IP-Dip Fit Values for Comparison.mat') ;
load('IP-S Fit Values for Comparison - v2.mat') ;
load('IP-Visio Fit Values for Comparison.mat') ;
load('IP-PDMS Fit Values for Comparison.mat');

YSCell{1,1} = IPSFitValues(:,7) ;
YSCell{1,2} = IPVisioFitValues(:,7) ;
YSCell{1,3} = IPDipFitValues(:,7) ;

Mods1Cell{1,1} = IPSFitValues(:,1) ;
Mods1Cell{1,2} = IPDipFitValues(:,1) ;
Mods1Cell{1,3} = IPVisioFitValues(:,1) ;
Mods1Cell{1,4} = IPPDMSFitValues(:, 1);

Mods2Cell{1,1} = IPSFitValues(:,2) ./ IPSFitValues(:,1) ;
Mods2Cell{1,2} = IPVisioFitValues(:,2) ./ IPVisioFitValues(:,1);
Mods2Cell{1,3} = IPDipFitValues(:,2) ./ IPDipFitValues(:,1) ;

Mods3Cell{1,1} = IPSFitValues(:,4) ./ IPSFitValues(:,1) ;
Mods3Cell{1,2} = IPVisioFitValues(:,4) ./ IPVisioFitValues(:,1);
Mods3Cell{1,3} = IPDipFitValues(:,4) ./ IPDipFitValues(:,1) ;

Lam1Cell{1,1} = IPSFitValues(:,3) ;
Lam1Cell{1,2} = IPVisioFitValues(:,3) ;
Lam1Cell{1,3} = IPDipFitValues(:,3) ;

Lam2Cell{1,1} = IPSFitValues(:,5) ;
Lam2Cell{1,2} = IPVisioFitValues(:,5) ;
Lam2Cell{1,3} = IPDipFitValues(:,5) ;

TickLabels = {"IP-S", "IP-Visio", "IP-Dip"} ;

path = "D:\TPP uTT IP-PDMS Analysis\Materials Comparison" ;
PlotSize1 = [15, 5, 5.3*3, 3*3] ;
PlotSize2 = [15, 5, 2.65*3, 3*3] ;
TitleFontSize = 18 ;
TextFontSize = 20 ;

% Create the plot
fig1 = figure('units', 'centimeters', 'Position', [13.5, 0.5, 15, 15]); hold on;
%customBoxPlot_noStats_ForPaper_v8(YSCell) ;
%customBoxPlot_withStats_v12 = 1 ; 
customBoxPlot_withStats_v12(YSCell) ;
ylim([0 112]) ;
yticks(linspace(0, 100, 5)) ;
xticklabels(TickLabels);
ylabel('Stress (MPa)', 'FontSize', 14);
title('Yield Stress', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', TextFontSize) ;
title("Yield Stress, \sigma_y", 'FontSize',TitleFontSize)
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName1 = 'Pow_YS_v1';
filename1 = fullfile(path,fileName1);  % Set your desired file name
print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
saveas(fig1, filename1, 'tiff');

% Transform data
Mods1Cell_log = Mods1Cell;
for i = 1:length(Mods1Cell)
    data = Mods1Cell{1, i};
    data(data <= 0) = NaN;  % Avoid -Inf for zero or negative values
    Mods1Cell_log{1, i} = log10(data);
end

fig2 = figure('units', 'centimeters', 'Position', [13.5, 0.5, 15, 15]); hold on;
customBoxPlot_withStats_v12(Mods1Cell_log, Mods1Cell) ;
ylim([log10(0) log10(3000)]) ;
yticks(log10([1 10 100 1000])) ;
yticklabels({'1','10','100','1000'}) ;
% ylim([0 2700])
% yticks(linspace(0, 2000, 5));
xticklabels({'IP-S', 'IP-Dip', 'IP-Visio', 'IP-PDMS'});
ylabel('Moduli (MPa)', 'FontSize', 14);
set(gca, 'FontSize', TextFontSize) ;
title("Young's Modulus, E_1", 'FontSize',TitleFontSize) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName2 = 'Pow_YM_v1';
filename2 = fullfile(path,fileName2);  % Set your desired file name
print(filename2, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
saveas(fig2, filename2, 'tiff');

fig3 = figure('units', 'centimeters', 'position', PlotSize2); hold on;
customBoxPlot_withStats_v12(Mods2Cell) ;
% ylim([0.3 0.6]) ;
% yticks(linspace(0.3, 0.6, 4)) ;
xticklabels(TickLabels);
% ylabel('Moduli Coef.', 'FontSize', 14);
set(gca, 'FontSize', TextFontSize) ;
title("E_2/E_1", 'FontSize',TitleFontSize) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName3 = 'Pow_2M_v1';
filename3 = fullfile(path,fileName3);  % Set your desired file name
print(filename3, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

fig4 = figure('units', 'centimeters', 'position', PlotSize2); hold on;
customBoxPlot_withStats_v12(Mods3Cell) ;
ylim([0 2.6]) ;
yticks(linspace(0,2,5)) ;
xticklabels(TickLabels);
% ylabel('Moduli Coef.');
set(gca, 'FontSize', TextFontSize) ;
title("E_3/E_1", 'FontSize',TitleFontSize) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName4 = 'Pow_3M_v1';
filename4 = fullfile(path,fileName4);  % Set your desired file name
print(filename4, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

fig5 = figure('units', 'centimeters', 'position', PlotSize2); hold on;
%subplot(1, 2, 1) ;
customBoxPlot_withStats_v12(Lam1Cell) ;
ylim([0 0.55]) ;
yticks(linspace(0,0.4,5)) ;
xticklabels(TickLabels);
% ylabel('Strain Coefficient', 'FontSize', 14);
%title('Strain Coefficient');
set(gca, 'FontSize', TextFontSize) ;
title("\lambda_1", 'FontSize',TitleFontSize)
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName5 = 'Pow_SC1_v1';
filename5 = fullfile(path,fileName5);  % Set your desired file name
print(filename5, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

fig6 = figure('units', 'centimeters', 'position', PlotSize2); hold on;
customBoxPlot_withStats_v12(Lam2Cell) ;
ylim([0 2.2]) ;
yticks(linspace(0,2,5)) ;
% ylabel('Strain Coefficient', 'FontSize', 14);
xticklabels(TickLabels);
set(gca, 'FontSize', TextFontSize) ;
title("\lambda_2", 'FontSize',TitleFontSize);
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

fileName6 = 'Pow_SC2_v1';
filename6 = fullfile(path,fileName6);  % Set your desired file name
print(filename6, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution