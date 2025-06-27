clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [ 5, 1, 2.5*3, 2.5*3 ]); hold on;

% Set Colors for Plotting
co = get(gca, 'ColorOrder');
n_colors = size(co, 1);

% Parameter Columns
ComparisonColumns = [ 1 6:12 16 ] ;

% Generate Proper Tables
Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
SEMColumn = AverageTable(2:end, 13) ;

% Look For Write Speed
SRCompColIdx = 1:size(Data,2)-1 ;
SRCompCol = size(Data,2) ;
[StrainRateComps, ~, SRCidx] = unique(Data(:,SRCompColIdx), 'rows');

for n = 15 %1:size(StrainRateComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SRCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,SRCompColIdx) ;
        ConstantParams(1,2) = string((double(ConstantParams(1,2))*50)/100) ; %Convert Power to mW
        Variables = double(Data(matchingRows, SRCompCol)) ;
        [Variables, sort_index] = sort(Variables);
        CompData = AverageData(matchingRows,:) ;
        CompData = CompData(sort_index, :) ;
        SEMArea = SEMColumn(matchingRows,1) ;
        SEMArea = SEMArea(sort_index, 1) ;
        Details = sprintf("%s, Power: %s mW, Speed: %s mm/s, w x h: %s x %s um, Slc x Hat: %s x %s um, Style: %s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            Stress = CompData{nn, 2}(:,1) ;
            StressStd = CompData{nn, 2}(:,2) ;
            Strain = CompData{nn, 3}(:,1) ;

            XFill = [ Strain ; flip(Strain) ]  ;
            YFill = [ Stress-StressStd*1.25 ; flip(Stress+StressStd*1.25)] ;
            fill( XFill, YFill, co(mod(nn-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.3); hold on;
            plothandles(nn) = plot(Strain, Stress, 'color', co(mod(nn-1, n_colors)+1, :), 'linewidth', 6) ; hold on ;

            MaxStressVals(nn,1) = max(Stress) ;
            MaxStrainVals(nn,1) = max(Strain) ;

            LegendString(nn,1) = string(Variables(nn,1)) + " \mum/s" ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 20, 'box', 'on', 'LineWidth', 5, 'edgecolor', 'none') ;
        title(leg, 'Strain Rate') ;
        ylabel("Stress (MPa)") ;
        xlabel("Strain") ;
        ylim([0 250 ] ) ;
        yticks(linspace(0,250,6)) ; 
        xlim([0 0.75 ]) ;
        xticks(linspace(0,0.75,6))

        ax = gca;
        set(gca, 'FontSize', 20);  % Adjusted font size
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.25;  % Increase the axis line width
        ax.TickLength = [0.01 0.01];  % Increase the length of the tick marks
        grid on;

        % Plot Save
        path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 3 - Tensile Testing Methods & Analysis" ;
        fileName = 'Stress Strain Rates Plot';
        filename1 = fullfile(path,fileName);  % Set your desired file name
        print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

% 
% lgd = legend('show', 'box', 'on', 'FontSize', 16, 'Location', 'northwest', 'edgecolor', 'none');

        % Reset Figure and Values
        hold off ;
        clear MaxStressVals MaxStrainVals plothandles Stress StressStd Strain LegendString ;

    end

end



