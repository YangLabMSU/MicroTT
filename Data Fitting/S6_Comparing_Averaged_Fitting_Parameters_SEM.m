clear ; clc ; close ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiments Fits.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 13 16 6:12 ] ;
SEMConditions = [ 1 ; 2 ; 3 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look for Write Speed
SEMCompColIdx = [1, 3] ;
[SEMComps, ~, SEMCidx] = unique(Data(:,SEMCompColIdx), 'rows');


i = 1 ;
for nnn = 1:size(SEMConditions,1)

    for n = 1:size(SEMComps, 1)

        if nnn == 1
            SEMRows = (double(Data(:, 2)) < 5) ;
        elseif nnn == 2
            SEMRows = (double(Data(:, 2)) < 8 & double(Data(:,2)) > 4) ;
        elseif nnn == 3
            SEMRows = (double(Data(:,2)) > 8 ) ;
        end

        % Find the indices of rows matching the current parameter combination
        RowMatch = (SEMCidx == n) ;
        matchingRows = RowMatch & SEMRows ;

        if sum(matchingRows) > 1

            ConstantParams = Data(matchingRows,SEMCompColIdx) ;
            SEMAreas = AveragedStretchExps(matchingRows,1) ;
            Variables = Data(matchingRows, [2 4:end]) ;
            CompData = AveragedStretchExps(matchingRows,12) ;

            if nnn == 1

                Details = sprintf("%s, Strain Rate: %s, Less than 5 um^2 Area", ...
                    ConstantParams(1,:)) ;

            elseif nnn == 2

                Details = sprintf("%s, Strain Rate: %s, Between 4 to 8 um^2 Area", ...
                    ConstantParams(1,:)) ;

            elseif nnn == 3

                Details = sprintf("%s, Strain Rate: %s, Greater than 8 um^2 Area", ...
                    ConstantParams(1,:)) ;

            end

            for nn = 1:size(CompData,1)

                SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
                FitParameters = CompData{nn,1} ;
                Mods = FitParameters(:, [1 2 4]) ;
                Lams = FitParameters(:, [3 5]) ;

                Vary(nn,1) = sprintf("SEM Area: %s, Power: %s, Speed: %s, Wxh: %s x %s, SxH: %s, Style: %s, Strain Rate: %s",...
                    Variables(nn,:)) ;

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
            CompDataTable{i,6} = Vary ;
            CompDataTable{i,7} = SEMArea ;

            ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

            i = i + 1 ;

            clear Modmeans Modstddevs Lammeans Lamstddevs SEMArea Variables Details;

        end
    end
end

% Create a figure
PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [0.35,0.12,0.55,0.74] ;

for n = 1:size(CompDataTable)

    CompDataPlot = CompDataTable(n,:) ;
    ComparativeParameterPlotting_SEM(CompDataPlot) ;

    % Define the directory where the figure will be saved
    newFolder = 'SEM Comparisons - Fit Parameters' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    if nnn == 1

        Details2 = sprintf("%s_StrainRate%s_Less4um2Area", ...
            ConstantParamsKeep(n,:)) ;

    elseif nnn == 2

        Details2 = sprintf("%s_StrainRate%s_4to8um2Area", ...
            ConstantParamsKeep(n,:)) ;

    elseif nnn == 3

        Details2 = sprintf("%s_StrainRate%s_Greater8um2Area", ...
            ConstantParamsKeep(n,:)) ;

    end

    disp(Details2);
    fileName = Details2+'.tiff';
    path = cd ;
    fullFilePath = fullfile(path, newFolder, fileName);

    % Save the figure as a JPEG file
    saveas(PlotFig, fullFilePath, 'tiff');
    pause(1) ;
    hold off ;

end
