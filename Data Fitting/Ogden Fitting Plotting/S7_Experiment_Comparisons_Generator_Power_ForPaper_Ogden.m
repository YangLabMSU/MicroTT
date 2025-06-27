clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;

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

for n = 13 %[11 12 13] %1:size(PowerComps, 1)

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

            LegendString(nn,1) = string(Variables(nn,1)) ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 12, 'box', 'on', 'LineWidth', 5, 'edgecolor', 'none') ;

        title(leg, 'Write Power (mW)') ;

        ylim([0 300]) ;
        yticks(linspace(0,300, 6)) ; 

        xlim([0 0.8]) ;
        xticks(round(linspace(0,0.8,5),2)) ;

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
        path = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Speed and Power" ;
        fileName = 'Stress Strain Power Plot';
        filename1 = fullfile(path,fileName);  % Set your desired file name
        print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution


    end

end



