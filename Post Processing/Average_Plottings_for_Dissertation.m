clear ; clc ; close all ;

% Plotting and Averaging Experiments
% Set Colors for Plotting
% co = get(gca, 'ColorOrder');
% n_colors = size(co, 1);

figure('units','normalized','Position',[0.27,0.33,0.28,0.5]) ;

load('Experiment Averages.mat') ;
AvgExpers = 3 ;

Stresses = averagedResults{AvgExpers, 2} ;
Strains = averagedResults{AvgExpers, 3} ;

% Average Plotting
StressStd = averagedResults{AvgExpers,4}(:,2) ;
Stress = averagedResults{AvgExpers,4}(:,1) ;

StrainStd = averagedResults{AvgExpers,5}(:,2) ;
Strain = averagedResults{AvgExpers,5}(:,1) ;

XFill = [ Strain ; flip(Strain) ]  ;
YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
%fill( XFill, YFill, co(mod(AvgExpers-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.5); hold on;
fill( XFill, YFill, [ 175/255, 100/255, 100/255 ], 'LineStyle', 'none', 'FaceAlpha', 0.5); hold on;
%plot(Strains, Stresses, 'linewidth', 2, 'Color', [ 26/255, 16/255, 173/255, 0.5 ] ) ; hold on ;
%plot(Strain, Stress, 'color', co(mod(AvgExpers-1, n_colors)+1, :), 'linewidth', 4) ; hold on ;
plot(Strain, Stress, 'color', [ 219/255, 2/255, 2/255 ] , 'linewidth', 4) ; hold on ;

legend("Standard Deviation", "Experiments", "", "", "Average", 'box', 'off', 'Location', 'northwest') ; 
xlabel("Strain", "FontSize", 14) ; 
ylabel("Stress (MPa)", "FontSize", 14) ; 
set(gca, 'FontSize', 12) ; 
ax = gca;
ax.LineWidth = 1.5; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks