clear ; clc ; close all ; 

SEMData = [ 22 29 36 43 50 ; 2.5794 3.4535 4.8379 6.7046 10.2241]' ;

fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 5 ]); hold on;
plot(SEMData(:,1), SEMData(:,2), '+','linewidth', 3, 'MarkerSize', 10)  ; 
yticks(round(linspace(0,12,7))) ;
ylim([0 12]) ; 
xticks([22 29 36 43 50]) ;
xlim([20 52]) ; 
set(gca, 'FontSize', 14) ;
ylabel('SEM Area (um^2)');
title('SEM Area', 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Power (mW)')
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
    