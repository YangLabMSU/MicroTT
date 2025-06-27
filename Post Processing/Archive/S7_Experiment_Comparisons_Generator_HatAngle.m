clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
HatCompColIdx = [1:7, size(Data,2)] ; 
HatCompCol = 8 ; 
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');


for n = 1:size(HatComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (HatCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,HatCompColIdx) ;
        Variables = Data(matchingRows, HatCompCol) ;
        CompData = AverageData(matchingRows,:) ;
        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
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
        title(leg, 'Hatch Style') ;

        % Define the directory where the figure will be saved
        newFolder = 'Hatch Style Comparisons' ;

        % Check if the folder exists, if not, create it
        if ~exist(newFolder, 'dir')
            mkdir(newFolder);
        end

        % Define the full path to save the JPEG file
        %ConstantParams(1,[6 7]) = string(double(ConstantParams(1,[6 7]))*100) ; 
        Details2 = sprintf("%s_Power%s_Spd%s_WxH%sx%s_SxH%sx%s_StrainRate%s", ...
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



