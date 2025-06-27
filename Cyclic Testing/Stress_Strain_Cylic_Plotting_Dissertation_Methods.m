function [PlotFig1, PlotFig2] = Stress_Strain_Cylic_Plotting_Dissertation_Methods(time, stress, fiberstrain, platestrain)

% Plot the original data points and the fitted sine wave
PlotFig1 = figure('Units', 'inches', 'Position', [10,5,6.5,5]);
subplot(2,1,1) ;
plot(time, stress, 'linewidth', 3); hold on;

set(gca, 'FontSize', 14) ;
title("Stress", 'FontSize',14) ;
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
title("Stress-Strain Curve", 'FontSize',12) ;
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
xticks(round(linspace(0, xLimits(2)-xLimits(2)*.1, 6),3)) ;
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




end