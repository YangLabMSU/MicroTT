clear ; clc ; close ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiments Fits.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look for Write Speed
HatCompColIdx = [1:7, size(Data,2)] ;
HatCompCol = 8 ;
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');



i = 1 ;
for n = 1:size(HatComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (HatCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,HatCompColIdx) ;
        Variables = Data(matchingRows, HatCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,12) ;
        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
            FitParameters = CompData{nn,1} ;
            Mods = FitParameters(:, [1 2 4]) ;
            Lams = FitParameters(:, [3 5]) ;

            if size(Mods,1) > 1

                Modmeans(nn,:) = mean(Mods);
                Modstddevs(nn,:) = std(Mods);

                % Calculate mean and standard deviation
                Lammeans(nn,:) = mean(Lams);
                Lamstddevs(nn,:) = std(Lams);

            else

                Modmeans(nn,:) = Mods ;
                Modstddevs(nn,:) = [ 0 0 0 ] ;

                % Calculate mean and standard deviation
                Lammeans(nn,:) = Lams ;
                Lamstddevs(nn,:) = [ 0 0 ] ;

            end

        end

        CompDataTable{i,1} = Modmeans ;
        CompDataTable{i,2} = Modstddevs ;
        CompDataTable{i,3} = Lammeans ;
        CompDataTable{i,4} = Lamstddevs ;
        CompDataTable{i,5} = Details ;
        CompDataTable{i,6} = Variables ;
        CompDataTable{i,7} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear Modmeans Modstddevs Lammeans Lamstddevs SEMArea Variables Details;

    end
end

% Create a figure
PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [0.35, 0.25,0.55, 0.50] ;

for n = 1:size(CompDataTable)

    CompDataPlot = CompDataTable(n,:) ;
    ComparativeParameterPlotting_HatchSlice(CompDataPlot) ;

    % Define the directory where the figure will be saved
    newFolder = 'Hatch Style Comparisons - Fit Parameters' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    Details2 = sprintf("%s_Power%s_Spd%s_WxH%sx%s_SxH%sx%s_StrainRate%s", ...
        ConstantParamsKeep(n,:)) ;

    disp(Details2);
    fileName = Details2+'.tiff';
    path = cd ;
    fullFilePath = fullfile(path, newFolder, fileName);

    % Save the figure as a JPEG file
    saveas(PlotFig, fullFilePath, 'tiff');
    pause(1) ;
    hold off ;

end
