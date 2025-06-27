clear ; clc ; close ;

% Generate Comparisons of Averages
% load('Average Stretch Table.mat') ;
load('Average Stretch IP-S - Sub 6-5-24 - Table.mat') ; 

%load('Average Stretch Data.mat') ;
load('Average Stretch IP-S - Sub 6-5-24 - Data.mat') ; 

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [7,2,10,7]) ;

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
HatCompColIdx = [1:7, size(Data,2)] ;
HatCompCol = 8 ;
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');


for n = 1:size(HatComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (HatCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,HatCompColIdx) ;
        ConstantParams(1,2) = string((double(ConstantParams(1,2))*50)/100) ; %Convert Power to mW
        Variables = Data(matchingRows, HatCompCol) ;
        CompData = AverageData(matchingRows,:) ;
        SEMArea = SEMColumn(matchingRows,1) ;
        Details = sprintf("%s, Power: %s mW, Speed: %s mm/s, w x h: %s x %s um,  Hat x Slc: %s x %s um, Strain Rate: %s um/s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            Stress = CompData{nn, 2}(:,1) ;
            StressStd = CompData{nn, 2}(:,2) ;
            Strain = CompData{nn, 3}(:,1) ;

            XFill = [ Strain ; flip(Strain) ]  ;
            YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
            fill( XFill, YFill, co(mod(nn-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.3); hold on;
            plothandles(nn) = plot(Strain, Stress, 'color', co(mod(nn-1, n_colors)+1, :), 'linewidth', 6) ; hold on ;

            MaxStressVals(nn,1) = max(Stress) ;
            MaxStrainVals(nn,1) = max(Strain) ;

            LegendString(nn,1) = string(sprintf('Hatch Style: %s, SEM Area: %s um^2', string(Variables(nn,1)), string(round(double(SEMArea(nn,1)),2)))) ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 18, 'box', 'on', 'LineWidth', 5, 'edgecolor', 'none') ;
        %title(Details, 'FontSize', 15) ;
        ylabel("Stress (MPa)") ;
        xlabel("Strain") ;
        ylim([0 90] ) ;
        yticks(linspace(0,90,7)) ; 
        xlim([0 0.9]) ;
        xticks(linspace(0,0.9,7))

        ax = gca;
        set(gca, 'FontSize', 24);  % Adjusted font size
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.25;  % Increase the axis line width
        ax.TickLength = [0.01 0.01];  % Increase the length of the tick marks
        grid on;

        % Define the directory where the figure will be saved
        newFolder = 'Hatch Style Comparisons - Averaged Curves - 6-5-24' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        Details2 = sprintf("%s_Power%s_Spd%s_WxH%sx%s_SxH%sx%s_StrainRate%s", ...
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



