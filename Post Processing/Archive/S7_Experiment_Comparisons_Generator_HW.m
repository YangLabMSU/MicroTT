clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
WHCompColIdx = [1:3, 6:size(Data,2)] ;
WHCompCol = [ 4 5 ] ;
[WHComps, ~, WHCidx] = unique(Data(:,WHCompColIdx), 'rows');

for n = 1:size(WHComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (WHCidx == n) ;

    if sum(matchingRows) > 1
        ConstantParams = Data(matchingRows,WHCompColIdx) ;
        Variables = Data(matchingRows, [4 5]) ;
        CompData = AverageData(matchingRows,:) ;
        Details = sprintf("%s, Power: %s, Speed: %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
            ConstantParams(1,:)) ;

        PlotFig = figure() ;
        PlotFig.Units = 'Normalized' ;
        PlotFig.Position = [ 0.25, 0.10, 0.5, 0.8 ] ;
        for nn = 1:size(CompData,1)

            Stress = CompData{nn, 2}(:,1) ;
            StressStd = CompData{nn, 2}(:,2) ;
            Strain = CompData{nn, 3}(:,1) ;

            % fill([Strain fliplr(Strain)], [Stress+StressStd fliplr(Stress-StressStd)], 'b'); % Fill the area between y1 and y2 with red color
            % hold on;

            plot(Strain, Stress, 'linewidth', 3) ; hold on ;

            Vary(nn) = Variables(nn,1) + 'x' + Variables(nn,2) ;
        end

        leg = legend(string(Vary), 'Location', 'northwest', 'FontSize', 15, 'box', 'off', 'LineWidth', 5) ;
        title(Details, 'FontSize', 15) ;
        title(leg, 'Width x Height (um)') ;

        % Define the directory where the figure will be saved
        newFolder = 'Design Size Comparisons' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        Details2 = sprintf("%s_Pow%s_Spd%s_SxH%sx%s_%s_StrainRate%s", ...
            ConstantParams(1,:)) ;
        fileName = Details2+'.tiff';
        path = cd ;
        fullFilePath = fullfile(path, newFolder, fileName);

        % Save the figure as a JPEG file
        saveas(PlotFig, fullFilePath, 'tiff');

        pause(2) ;

        % Optionally, close the figure
        close(gcf);
    end

end



