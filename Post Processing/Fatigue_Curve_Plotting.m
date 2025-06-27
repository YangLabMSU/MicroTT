clear ; clc ; close ;

% Plotting the Fatigue Experiments
load('Average Stretch IP-S Fatigue Data.mat') ;


for n = 1:size(Comps, 1)

    figure('units','inches','Position',[ 13.5, 5, 9, 5 ]) ;

    % Find the indices of rows matching the current parameter combination
    matchingRows = (CompIdx == n) ;
    Paths = ExpTable(matchingRows,27) ;
    
    for nn = 1:size(Paths,1)

        path = Paths(nn) ;
        load(path) ;

        StretchIdx = round(ProcessedData.StretchIdx(1)):1:round(ProcessedData.StretchIdx(2)) ;

        % disp('The variable Stretch Idx exists.');
        StrainData = ProcessedData.PlateStrain(StretchIdx) - ProcessedData.PlateStrain(StretchIdx(1)) ;
        StressData = ProcessedData.Stress(StretchIdx) - ProcessedData.Stress(StretchIdx(1)) ;
        plot(StrainData, StressData, 'linewidth', 2) ; hold on ;
        LegendName(nn) = "Strain Event: " + nn ;
        
    end

    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xLimits = xlim ;
    xticks(round(linspace(0,xLimits(2)-0.05,6),2)) ;
    ylabel('Stress (MPa)', 'FontSize', 14) ;
    xlabel('Strain', 'FontSize', 14) ; 
    set(gca, 'FontSize', 14) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    legend(LegendName, 'box', 'off', 'FontSize', 12, 'Location', 'northwest')
    grid on ;

    clear LegendName ; 

end


