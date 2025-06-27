clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
SpdCompColIdx = [1:2, 4:size(Data,2)] ; 
[SpdComps, ~, SCidx] = unique(Data(:,SpdCompColIdx), 'rows');


for n = 1:size(SpdComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SCidx == n) ;

    if sum(matchingRows) > 1
        ConstantParams = Data(matchingRows,SpdCompColIdx) ;
        Variables = Data(matchingRows, 3) ;
        CompData = AverageData(matchingRows,:) ;
        Details = sprintf("%s, Power: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
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
        end
        leg = legend(string(Variables), 'Location', 'northwest', 'FontSize', 15, 'box', 'off', 'LineWidth', 5) ;
        title(Details, 'FontSize', 15) ;
        title(leg, 'Write Speed (mm/s)') ;

        % Define the directory where the figure will be saved
        newFolder = 'Speed Comparisons' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        %ConstantParams(1,[6 7]) = string(double(ConstantParams(1,[6 7]))*100) ; 
        Details2 = sprintf("%s_Pow%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
            ConstantParams(1,:)) ;
        fileName = Details2+'.tiff';
        %fileName = "Check.tiff" ;
        path = cd ; 
        fullFilePath = fullfile(path, newFolder, fileName);

        % Save the figure as a JPEG file
        saveas(PlotFig, fullFilePath, 'tiff');

        pause(2) ;

        % Optionally, close the figure
        close(PlotFig);
    end

end



