clear ; clc ; close ;

% Plotting the Fatigue Experiments
load('Average Stretch IP-S Fatigue Data.mat')
figure('units','inches','Position',[13.5,3.5,8.5,3]) ;
ax = gca ; 
colors = colororder(ax) ; 

for n = 1:size(AverageData, 1)

    % Average Plotting
    StressStd = AverageData{n,2}(:,2) ;
    Stress = AverageData{n,2}(:,1) ;

    StrainStd = AverageData{n,3}(:,2) ;
    Strain = AverageData{n,3}(:,1) ;

    XFill = [ Strain ; flip(Strain) ]  ;
    YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
    fill( XFill, YFill, colors(n,:), 'LineStyle', 'none', 'FaceAlpha', 0.5) ; hold on ; 

end

for n = 1:size(AverageData, 1)

    % Average Plotting
    Stress = AverageData{n,2}(:,1) ;
    Strain = AverageData{n,3}(:,1) ;
    
    plot(Strain, Stress, 'color', colors(n,:), 'linewidth', 4) ; hold on ;

end

yLimits = ylim ;
yticks(round(linspace(yLimits(1),yLimits(2),6))) ;
xLimits = xlim ;
xticks(round(linspace(0,xLimits(2),6),2)) ;
ylabel('Stress (MPa)', 'FontSize', 14) ;
xlabel('Strain', 'FontSize', 14) ;
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
LegendName = {"", "", "", "Strain Event: 1",  "Strain Event: 2", "Strain Event: 3"} ; 
legend(LegendName, 'box', 'off', 'FontSize', 12, 'Location', 'northwest')
title("IP-S Fiber Recovery and Material Integrity", 'FontSize', 14) ; 
grid on ;


