function customBoxPlot_withStats_v10(dataCell)

% Check if dataCell is a cell array
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

% Number of categories
numCategories = length(dataCell);

% Initialize maxValues array
maxValues = zeros(1, numCategories);
LineWidthVal = 2;

for n = 1:numCategories

    Data = dataCell{n};
    Data = Data(~isnan(Data));
    
    if ~isempty(Data)
        % Calculate necessary statistics
        meanValue = mean(Data);
        stdDev = std(Data);
        minValue = min(Data);
        maxValue = max(Data);
        maxValues(n) = max(Data);
        minValues(n) = min(Data);

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

    end
end

% Perform pairwise t-tests and annotate significance levels
numComparisons = nchoosek(numCategories, 2);
yOffset = max(maxValues) * 0.15;
compCount = 1;

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

            % Define position for the annotation
            xPos = (i + j) / 2;
            yPos = max(maxValues) + yOffset * compCount;

            % Annotate the significance level
            text(xPos, yPos + (yOffset * 0.4), sigStars, 'HorizontalAlignment', 'center', 'FontSize', 24, 'FontWeight', 'bold', 'Color', 'k');
            
            % Draw the bracket
            line([i, i, j, j], [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], 'Color', 'k', 'linewidth', LineWidthVal);
            
            compCount = compCount + 1;
        end
    end
end

% Adjust y-axis limits to ensure all annotations are visible
YBotLim = min(minValues) - min(minValues) * 1;
YTopLim = max(maxValues) + yOffset * (compCount + 1);
ylim([YBotLim YTopLim]);

% Customize the plot
xlim([0.5, numCategories + 0.5]);
xticks(1:numCategories);

end
