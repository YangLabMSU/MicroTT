function customBoxPlot_withStats_v10(dataCell)

% Check if dataCell is a cell array
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

% Number of categories
numCategories = length(dataCell);

% Initialize maxValues array
maxValues = zeros(1, numCategories);
LineWidthVal = 2 ; 

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
        boxwidth = 0.35;

        % Plot the whiskers
        if boxBottom > minValue && boxTop < maxValue
            plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', LineWidthVal); hold on;
            plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', LineWidthVal);
            plot([n - (boxwidth / 4), n + (boxwidth / 4)], [maxValue, maxValue], 'k-', 'LineWidth', LineWidthVal);
            plot([n - (boxwidth / 4), n + (boxwidth / 4)], [minValue, minValue], 'k-', 'LineWidth', LineWidthVal);
        end

        fill([n - (boxwidth / 2), n + (boxwidth / 2), n + (boxwidth / 2), n - (boxwidth / 2)], [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', LineWidthVal); hold on;

        % Plot the average line
        plot([n - (boxwidth / 2), n + (boxwidth / 2)], [meanValue, meanValue], 'r-', 'LineWidth', LineWidthVal);

        % Overlay the data points
        numPoints = length(Data);
        x = (n - (boxwidth / 4)) + ((n + (boxwidth / 4)) - (n - (boxwidth / 4))) * rand(numPoints, 1);
        plot(x, Data, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

        % Label the average value
        %text(n + (boxwidth / 1.1), meanValue, sprintf('%.2f', meanValue), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');

    end
end


% Perform pairwise t-tests and annotate p-values
numComparisons = nchoosek(numCategories, 2);
compCount = 1 ;
SigCount = 0 ;
yOffset = max(maxValues) * 0.15;

for i = 1:numCategories
    for j = i+1:numCategories
        [~, p] = ttest2(dataCell{i}, dataCell{j});
        % Define position for the annotation
        comparisonCount = abs(i-j) ;
        if p < 0.05 && comparisonCount < 4
            xPos = (i + j) / 2;
            if comparisonCount > 1
                compCount = compCount + 1;
                comparisonCount = compCount ;
                % if SigCount == 0
                %     compCount = compCount - 1 ;
                %     comparisonCount = compCount ;
                % end
            end
            yPos = max(maxValues) + yOffset * comparisonCount ;
            % Annotate the p-value
            text(xPos, yPos+(yOffset*0.4), sprintf('p = %.3f', round(p,3)), 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
            % Draw the bracket
            line([i, i, j, j], [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], 'Color', 'k', 'linewidth', LineWidthVal);
            SigCount = SigCount + 1 ;
        end
    end
end

% Adjust y-axis limits to ensure all annotations are visible
YBotLim = min(minValues)-min(minValues)*1 ;
YTopLim = max(maxValues)+yOffset*(compCount+1) ;
ylim([YBotLim YTopLim]);

% Customize the plot
xlim([0.5, numCategories + 0.5]);
xticks(1:numCategories);


end
