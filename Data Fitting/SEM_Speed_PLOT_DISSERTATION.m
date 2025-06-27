clear ; clc ; close all ; 


SEMData = [ 8 16 24 32 40 48 56 64 72 80 ; 13.3755 10.8495 9.5974 8.5411 8.476 7.6749 7.0569 6.7062 6.9374 5.6782 ]' ;

fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 4 ]); hold on;
plot(SEMData(:,1), SEMData(:,2), '+','linewidth', 3, 'MarkerSize', 10)  ; 
yticks(round(linspace(2,14,7))) ;
ylim([0 14]) ; 
xticks([8 16 24 32 40 48 56 64 72 80]) ;
xlim([4 84]) ; 
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
    