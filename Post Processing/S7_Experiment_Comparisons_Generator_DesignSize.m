clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

% Generate the Figure for Plotting
PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.25, 0.10, 0.5, 0.8 ] ;

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
WHCompColIdx = [1:3, 6:size(Data,2)] ;
WHCompCol = [ 4 5 ] ;
[WHComps, ~, WHCidx] = unique(Data(:,WHCompColIdx), 'rows');

for n = 1:size(WHComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (WHCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,WHCompColIdx) ;
        ConstantParams(1,2) = string((double(ConstantParams(1,2))*50)/100) ; %Convert Power to mW
        Variables = double(Data(matchingRows, WHCompCol)) ;
        [~, sort_index] = sort(Variables(:,1));
        Variables = Variables(sort_index,:) ;
        Variables = Variables(:,1) + " x " + Variables(:,2) ;
        CompData = AverageData(matchingRows,:) ;
        CompData = CompData(sort_index, :) ;
        SEMArea = SEMColumn(matchingRows,1) ;
        SEMArea = SEMArea(sort_index, 1) ;
        Details = sprintf("%s, Power: %s mW, Speed: %s mm/s, Slc x Hat: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
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

            LegendString(nn,1) = string(sprintf('w x h: %s um, SEM Area: %s um^2', string(Variables(nn,1)), string(SEMArea(nn,1)))) ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 15, 'box', 'off', 'LineWidth', 5) ;
        title(leg, 'Design Size Comparison') ;
        title(Details, 'FontSize', 15) ;
        ylabel("Stress (MPa)") ;
        xlabel("Strain") ;
        ylim([0 max(MaxStressVals)*1.05 ] ) ;
        xlim([0 max(MaxStrainVals)*1.05 ] ) ;
        grid on ;
        set(gca, 'FontSize', 15, 'FontName', 'Arial') ;

        % Define the directory where the figure will be saved
        newFolder = 'Design Size Comparisons - Averaged Curves' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        Details2 = sprintf("%s_Pow%s_Spd%s_SxH%sx%s_%s_StrainRate%s", ...
            ConstantParams(1,:)) ;
        fileName = Details2 + '.tiff' ;
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



