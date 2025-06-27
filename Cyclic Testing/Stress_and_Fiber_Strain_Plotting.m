function PlotFig3 = Stress_and_Fiber_Strain_Plotting(StressPktime, StressPk, FibStrainPktime, FibStrainPk, FibStrainTrtime, FibStrainTr)

    % Plot the original data points and the fitted sine wave
    PlotFig3 = figure('Units', 'inches', 'Position', [16.5,4,5.25,6]);
    subplot(3,1,1) ;
    plot(StressPktime, StressPk, '-x', 'linewidth', 3); hold on;
    set(gca, 'FontSize', 14) ;
    title("Stress Peaks", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+0.05, yLimits(2)-0.05, 4),1)) ;
    xlim([0 max(StressPktime)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Stress (MPa)', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;

    subplot(3,1,2) ;
    yyaxis left ;
    plot(FibStrainPktime, FibStrainPk, '-x', 'linewidth', 3); hold on;
    %plot(FibStrainTrtime, FibStrainTr, '-x', 'linewidth', 3);
    set(gca, 'FontSize', 14) ;
    title("Fiber Strain Peaks and Troughs", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ; 
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+yLimits(1)*0.001, yLimits(2)-yLimits(2)*0.001, 4),4)) ;
    xlim([0 max(FibStrainPktime)*1.05])
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-1,6))) ;
    ylabel('Strain', 'FontSize', 14);
    xlabel("Time (s)", "FontSize", 14) ;
    
    yyaxis right ; 
    plot(FibStrainTrtime, FibStrainTr, '-x', 'linewidth', 3);
    yLimits = ylim ;
    % yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+yLimits(1)*0.01, yLimits(2)-yLimits(2)*0.01, 4),4)) ;
    legend("Peaks", "Troughs", 'Location', 'southeast', 'fontsize', 8, 'box', 'off') ; 

    subplot(3,1,3) ;
    FibStrainDiff = FibStrainPk(1:size(FibStrainTr,1)) - FibStrainTr ; 
    plot(FibStrainDiff, '-x', 'linewidth', 3);
    set(gca, 'FontSize', 14) ;
    title("Fiber Strain Difference", 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on 
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+yLimits(1)*0.01, yLimits(2)-yLimits(2)*0.01, 4),3)) ;
    xLimits = xlim ;
    xticks(round(linspace(1,xLimits(2),6))) ;
    ylabel('Strain Difference', 'FontSize', 14);
    xlabel("Strain Cycle", "FontSize", 14) ;


end
