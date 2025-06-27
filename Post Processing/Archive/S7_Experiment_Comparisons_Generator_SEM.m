clear ; clc ; close ;

% Generate Comparisons of Averages
load('Average Stretch Table.mat') ;
load('Average Stretch Data.mat') ;

SEMConditions = [ 1 ; 2 ; 3 ] ;
ComparisonColumns = [ 1 13 16 6:12 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
SEMCompColIdx = [1, 3] ;
[SEMComps, ~, SEMCidx] = unique(Data(:,SEMCompColIdx), 'rows');

co = get(gca, 'ColorOrder');
n_colors = size(co, 1);

for nnn = 1:size(SEMConditions,1)

    for n = 1:size(SEMComps, 1)

        % Find the indices of rows matching the current parameter combination

        if nnn == 1

            SEMRows = (double(Data(:, 2)) < 5) ;

        elseif nnn == 2

            SEMRows = (double(Data(:, 2)) < 8 & double(Data(:,2)) > 4) ;

        elseif nnn == 3

            SEMRows = (double(Data(:,2)) > 8 ) ;

        end

        RowMatch = (SEMCidx == n) ;
        matchingRows = RowMatch & SEMRows ;

        if sum(matchingRows) > 1
            
            ConstantParams = Data(matchingRows,SEMCompColIdx) ;
            Variables = Data(matchingRows, [2 4:end]) ;
            CompData = AverageData(matchingRows,:) ;

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


            PlotFig = figure() ;
            PlotFig.Units = 'Normalized' ;
            PlotFig.Position = [ 0.25, 0.10, 0.5, 0.8 ] ;
            
            for nn = 1:size(CompData,1)

                Stress = CompData{nn, 2}(:,1) ;
                StressStd = CompData{nn, 2}(:,2) ;
                Strain = CompData{nn, 3}(:,1) ;

                XFill = [ Strain ; flip(Strain) ]  ;
                YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;           
                fill( XFill, YFill, co(mod(nn-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.25); hold on;
                plothandles(nn) = plot(Strain, Stress, 'color', co(mod(nn-1, n_colors)+1, :), 'linewidth', 3) ; hold on ;             
                Vary(nn) = sprintf("SEM Area: %s, Power: %s, Speed: %s, Wxh: %s x %s, SxH: %s, Style: %s, Strain Rate: %s",...
                    Variables(nn,:)) ;

            end

            leg = legend(plothandles, string(Vary),...
                'Location', 'northwest', 'FontSize', 12, 'box', 'off', 'LineWidth', 5) ;
            title(Details, 'FontSize', 15) ;
            title(leg, 'Fiber Parameters') ;

            % Define the directory where the figure will be saved
            newFolder = 'SEM Comparisons - v2' ;

            % Check if the folder exists, if not, create it
            if ~exist(newFolder, 'dir')
                mkdir(newFolder);
            end

            % Define the full path to save the JPEG file
            if nnn == 1

                Details2 = sprintf("%s_StrainRate%s_Less4um2Area", ...
                    ConstantParams(1,:)) ;

            elseif nnn == 2

                Details2 = sprintf("%s_StrainRate%s_4to8um2Area", ...
                    ConstantParams(1,:)) ;

            elseif nnn == 3

                Details2 = sprintf("%s_StrainRate%s_Greater8um2Area", ...
                    ConstantParams(1,:)) ;

            end


            fileName = Details2+'.tiff';
            path = cd ;
            fullFilePath = fullfile(path, newFolder, fileName);

            % Save the figure as a JPEG file
            saveas(PlotFig, fullFilePath, 'tiff');

            pause(2) ;

            % Optionally, close the figure
            close(PlotFig);
            clear Vary plothandles ; 
        end

    end
end


