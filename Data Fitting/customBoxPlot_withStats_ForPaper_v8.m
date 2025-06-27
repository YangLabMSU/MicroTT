function customBoxPlot_withStats_ForPaper_v8(dataCell)

% Check if dataCell is a cell array
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

% Number of categories
numCategories = length(dataCell);

% Initialize maxValues array
maxValues = zeros(1, numCategories);

for n = 1:numCategories

    Data = dataCell{n};
    Data = Data(~isnan(Data)) ;
    
    if ~isempty(Data)
        % Calculate necessary statistics
        TrendData(n) = mean(Data);
    end
end

datavec = linspace(1,numCategories,100) ;
TrendData = interp1(1:numCategories,TrendData,datavec) ; 
plot(datavec,smooth(smooth(TrendData)), '-.', 'color', "#2d9669", 'LineWidth',3) ; hold on ; 

for n = 1:numCategories

    Data = dataCell{n};
    Data = Data(~isnan(Data)) ;
    
    if ~isempty(Data)
        % Calculate necessary statistics
        meanValue = mean(Data);
        stdDev = std(Data);
        minValue = min(Data);
        maxValue = max(Data);
        maxValues(n) = max(Data);
        minValues(n) = min(Data) ;

        % Define the box boundaries
        boxBottom = meanValue - stdDev;
        boxTop = meanValue + stdDev;

        % Plot the box
        boxwidth = 0.5;

        % Plot the whiskers
        if boxBottom > minValue && boxTop < maxValue

                plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', 2); hold on;
                plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', 2);
                plot([n - (boxwidth / 4), n + (boxwidth / 4)], [maxValue, maxValue], 'k-', 'LineWidth', 2);
                plot([n - (boxwidth / 4), n + (boxwidth / 4)], [minValue, minValue], 'k-', 'LineWidth', 2);

        end

        fill([n - (boxwidth / 2), n + (boxwidth / 2), n + (boxwidth / 2), n - (boxwidth / 2)], [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', 2); hold on;

        % Plot the average line
        plot([n - (boxwidth / 2), n + (boxwidth / 2)], [meanValue, meanValue], 'r-', 'LineWidth', 2);

        % Overlay the data points
        numPoints = length(Data);
        x = (n - (boxwidth / 4)) + ((n + (boxwidth / 4)) - (n - (boxwidth / 4))) * rand(numPoints, 1);
        plot(x, Data, 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'b');

        % % Label the average value
        % text(n + (boxwidth / 1.1), meanValue, sprintf('%.2f', meanValue), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');

    end
end


% Perform pairwise t-tests and annotate p-values
numComparisons = nchoosek(numCategories, 2);
compCount = 1 ;
SigCount = 0 ;
yOffset = max(maxValues) * 0.05;

for i = 1:numCategories
    for j = i+1:numCategories
        [~, p] = ttest2(dataCell{i}, dataCell{j});
        
        % Determine significance level
        if p < 0.05

            if p < 0.001
                sigStars = '***';
            elseif p < 0.01
                sigStars = '**';
            else
                sigStars = '*';
            end

            comparisonCount = abs(i-j) ;
            if comparisonCount > 1
                compCount = compCount + 1;
                comparisonCount = compCount ;
            end

            if max(maxValues) > 0

                % Define position for the annotation
                xPos = (i + j) / 2;
                yPos = max(maxValues) + yOffset * comparisonCount;

                % Annotate the significance level
                text(xPos, yPos + (yOffset * 0.4), sigStars, 'HorizontalAlignment', 'center', 'FontSize', 24, 'FontWeight', 'bold', 'Color', 'k');

                % Draw the bracket
                line([i, i, j, j], [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], 'Color', 'k', 'linewidth', 2);

            elseif max(maxValues) < 0

                    yOffsetAdj = -yOffset ;

                % yOffset = yOffset*2 ; 

                % Define position for the annotation
                xPos = (i + j) / 2;
                yPos = max(maxValues) + yOffsetAdj * comparisonCount*1.2;

                % Annotate the significance level
                text(xPos, yPos + (yOffsetAdj * 0.4), sigStars, 'HorizontalAlignment', 'center', 'FontSize', 24, 'FontWeight', 'bold', 'Color', 'k');

                % Draw the bracket
                line([i, i, j, j], [yPos - yOffsetAdj/4, yPos, yPos, yPos - yOffsetAdj/4], 'Color', 'k', 'linewidth', 2);

            end
            
            compCount = compCount + 1;
        end
    end
end


% for i = 1:numCategories
%     for j = i+1:numCategories
%         [~, p] = ttest2(dataCell{i}, dataCell{j});
%         % Define position for the annotation
%         comparisonCount = abs(i-j) ;
%         if p < 0.05 && comparisonCount < 4
%             xPos = (i + j) / 2;
%             if comparisonCount > 1
%                 compCount = compCount + 1;
%                 comparisonCount = compCount ;
%                 % if SigCount == 0
%                 %     compCount = compCount - 1 ;
%                 %     comparisonCount = compCount ;
%                 % end
%             end
%             yPos = max(maxValues) + yOffset * comparisonCount ;
%             % Annotate the p-value
%             text(xPos, yPos+(yOffset*0.4), sprintf('p = %.3f', round(p,3)), 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'k');
%             % Draw the bracket
%             line([i, i, j, j], [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], 'Color', 'k', 'linewidth', 1.25);
%             SigCount = SigCount + 1 ;
%         end
%     end
% end

% Adjust y-axis limits to ensure all annotations are visible
YBotLim = min(minValues)-min(minValues)*0.5 ;
YTopLim = max(maxValues)+yOffset*(compCount+1) ;
%ylim([YBotLim YTopLim]);

% Customize the plot
xlim([0.5, numCategories + 0.5]);
xticks(1:numCategories);


end
