clear ; clc ; close ;

% Generate Comparisons of Averages
% load('Average Stretch Table.mat') ;
% load('Average Stretch Data.mat') ;
load('Average Stretch Table - Sub 6-14.mat') ;
load('Average Stretch Data - Sub 6-14.mat') ;

% Generate the Figure for Plotting
%PlotFig = figure('units', 'inches', 'Position', [7,2,11,6]) ;
PlotFig = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;

% Set Colors for Plotting
n_colors = 10; % Number of colors you want to sample
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

% Look For Write Speed
SpdCompColIdx = [1:2, 4:size(Data,2)] ;
SpdCompCol = 3 ;
[SpdComps, ~, SCidx] = unique(Data(:,SpdCompColIdx), 'rows');

for n = 1:size(SpdComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,SpdCompColIdx) ;
        ConstantParams(1,2) = string((double(ConstantParams(1,2))*50)/100) ; %Convert Power to mW
        Variables = double(Data(matchingRows, SpdCompCol)) ;
        [Variables, sort_index] = sort(Variables, 'descend');
        CompData = AverageData(matchingRows,:) ;
        CompData = CompData(sort_index, :) ;
        SEMArea = SEMColumn(matchingRows,1) ;
        SEMArea = SEMArea(sort_index, 1) ;
        Details = sprintf("%s, Power: %s mW, Wxh: %s x %s um, SxH: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
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

            %LegendString(nn,1) = string(sprintf("%s mm/s", string(Variables(nn,1)))) ;
            LegendString(nn,1) = string(string(Variables(nn,1))) ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 11, 'box', 'on', 'LineWidth', 5, 'edgecolor', 'none', 'NumColumns',2) ;

        title(leg, 'Write Speed (mm/s)') ;

        ylim([0 160]) ;
        yticks(linspace(0,160, 6)) ;

        xlim([-0.05 1]) ;
        xticks(linspace(0,1,6)) ;

        set(gca, 'FontSize', 18) ;
        xlabel('Strain') ;
        ylabel('Stress (MPa)') ;
        ax = gca;
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.25 ; % Increase the axis line width
        ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
        grid on ;

        % Plot Save
        %path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 5 - Writing Speed Evaluation" ;
        path = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Speed and Power" ;
        fileName = 'Stress Strain Speed Plot';
        filename1 = fullfile(path,fileName);  % Set your desired file name
        print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    end

end



