clear ; clc ; close ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Ogden Experiments - v1.mat') ;
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

load('Average Ogden Experiments - v1 - Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 2 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
MatchTable = AverageTable(2:end,:) ;

% Look for Write Speed
SRCompColIdx = 1:size(Data,2)-1 ;

SRCompCol = size(Data,2) ;

[StrainRateComps, ~, SRCidx] = unique(Data(:,SRCompColIdx), 'rows');

for n = 1:size(StrainRateComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SRCidx == n) ;

    if sum(matchingRows) > 1

        % ConstantParams = Data(matchingRows,SRCompColIdx) ;
        % ConstantParams(1,2) = string((double(ConstantParams(1,2))*50)/100) ; %Convert Power to mW
        % Variables = double(Data(matchingRows, SRCompCol)) ;
        % [Variables, sort_index] = sort(Variables);
        % CompData = AverageData(matchingRows,:) ;
        % CompData = CompData(sort_index, :) ;
        % SEMArea = SEMColumn(matchingRows,1) ;
        % SEMArea = SEMArea(sort_index, 1) ;

        ConstantParams = Data(matchingRows,SRCompColIdx) ;
        Variables = Data(matchingRows, SRCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,6) ;

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
                
        title(leg, 'Write Power (mW)') ;

        ylim([0 300]) ;
        yticks(linspace(0,300, 6)) ; 

        xlim([0 0.8]) ;
        xticks(round(linspace(0,0.8,9),2)) ;


        set(gca, 'FontSize', 14) ;
        xlabel('Strain') ;
        ylabel('Stress (MPa)') ;
        ax = gca;
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.25 ; % Increase the axis line width
        ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
        grid on ;

        % % Plot Save
        % path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 3 - Tensile Testing Methods & Analysis" ;
        % fileName = 'Stress Strain Rates Plot';
        % filename1 = fullfile(path,fileName);  % Set your desired file name
        % print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

        % Reset Figure and Values
        hold off ;
        clear MaxStressVals MaxStrainVals plothandles Stress StressStd Strain LegendString ;

    end

end



