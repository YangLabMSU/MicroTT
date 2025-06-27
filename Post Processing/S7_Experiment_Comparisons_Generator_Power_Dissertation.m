clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

% Generate the Figure for Plotting
% PlotFig = figure() ;
% PlotFig.Units = 'inches' ;
% %PlotFig.Position = [ 17.5,3.5,7,5] ;
% PlotFig.Position = [3,2,5,5] ;

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [7,2,11,6]) ;

% Set Colors for Plotting
n_colors = 5; % Number of colors you want to sample
parula_colors = parula(n_colors);
% Apply the new color order
set(gca, 'ColorOrder', parula_colors, 'NextPlot', 'replacechildren');
co = get(gca, 'ColorOrder');
n_colors = size(co, 1);

% Parameter Columns
ComparisonColumns = [ 1 6:12 16 ] ;

% Generate Proper Tables
Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
SEMColumn = AverageTable(2:end, 13) ;

% Look For Strain Rate
PowCompColIdx = [1, 3:size(Data,2)] ;
PowCompCol = 2 ;
[PowerComps, ~, PCidx] = unique(Data(:,PowCompColIdx), 'rows');

for n = [11 12 13] %1:size(PowerComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (PCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,PowCompColIdx) ;
        Variables = double(Data(matchingRows, PowCompCol)) ;
        [Variables, sort_index] = sort(Variables);
        Variables = (Variables.*50 / 100) ; 
        CompData = AverageData(matchingRows,:) ;
        CompData = CompData(sort_index, :) ;
        SEMArea = SEMColumn(matchingRows,1) ;
        SEMArea = SEMArea(sort_index, 1) ;
        Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, Slc x Hat: %s x %s um,\n Style: %s, Strain Rate: %s um/s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            Stress = CompData{nn, 2}(:,1) ;
            StressStd = CompData{nn, 2}(:,2) ;
            Strain = CompData{nn, 3}(:,1) ;

            XFill = [ Strain ; flip(Strain) ]  ;
            YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
            fill( XFill, YFill, co(mod(nn-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.3); hold on;
            plothandles(nn) = plot(Strain, Stress, 'color', co(mod(nn-1, n_colors)+1, :), 'linewidth', 4) ; hold on ;

            MaxStressVals(nn,1) = max(Stress) ;
            MaxStrainVals(nn,1) = max(Strain) ;

            LegendString(nn,1) = string(sprintf('Power: %s mW', string(Variables(nn,1)))) ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 15, 'box', 'off', 'LineWidth', 5) ;
        title(leg, 'Write Power Comparison') ;        
        ylabel("Stress (MPa)") ;
        xlabel("Strain") ;
        ylim([0 max(MaxStressVals)*1.05 ] ) ;
        yLimits = ylim ;
        yticks(round(linspace(0,yLimits(2)-2,6))) ;
        xlim([0 max(MaxStrainVals)*1.05 ] ) ;
        xlimits = xlim ; 
        xticks(round(linspace(xlimits(1)+0.01,xlimits(2)-0.01,6),2)) ;
        grid on ;
        set(gca, 'FontSize', 15, 'FontName', 'Arial') ;
        %title(Details, 'FontSize', 13) ;
        ax = gca;
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.5 ; % Increase the axis line width
        ax.TickLength = [0.015 0.015]; % Increase the length of the tick marks
        grid on ;


        % Define the directory where the figure will be saved
        newFolder = 'Power Comparisons - Averaged Curves - Dissertation' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        Details2 = sprintf("%s_Spd%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
            ConstantParams(1,:)) ;
        fileName = Details2 + '_v2.tiff' ;
        path = cd ;
        fullFilePath = fullfile(path, newFolder, fileName);

        % Save the figure as a JPEG file
        saveas(PlotFig, fullFilePath, 'tiff');
        pause(2) ;

        % Reset Figure and Values
        hold off ;
        clear MaxStressVals MaxStrainVals plothandles Stress StressStd Strain LegendString ;

    end

end



