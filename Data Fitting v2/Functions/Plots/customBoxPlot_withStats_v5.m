function customBoxPlot_withStats_v5(dataCell)

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
            plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', 1.25); hold on;
            plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', 1.25);
            plot([n - (boxwidth / 4), n + (boxwidth / 4)], [maxValue, maxValue], 'k-', 'LineWidth', 1.25);
            plot([n - (boxwidth / 4), n + (boxwidth / 4)], [minValue, minValue], 'k-', 'LineWidth', 1.25);
        end

        fill([n - (boxwidth / 2), n + (boxwidth / 2), n + (boxwidth / 2), n - (boxwidth / 2)], [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', 1.25); hold on;

        % Plot the average line
        plot([n - (boxwidth / 2), n + (boxwidth / 2)], [meanValue, meanValue], 'r-', 'LineWidth', 2);

        % Overlay the data points
        numPoints = length(Data);
        x = (n - (boxwidth / 4)) + ((n + (boxwidth / 4)) - (n - (boxwidth / 4))) * rand(numPoints, 1);
        plot(x, Data, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

        % Label the average value
        text(n + (boxwidth / 1.1), meanValue, sprintf('%.2f', meanValue), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');
    end


    % Perform pairwise t-tests and annotate p-values
    numComparisons = nchoosek(numCategories, 2);
    comparisonCount = 1;
    yOffset = max(maxValues) * 0.15;

    for i = 1:numCategories
        for j = i+1:numCategories
            [~, p] = ttest2(dataCell{i}, dataCell{j});
            % Define position for the annotation
            xPos = (i + j) / 2;
            comparisonCount = abs(i-j) ; 
            yPos = max(maxValues) + yOffset * comparisonCount ;
            % Annotate the p-value
            text(xPos, yPos+(yOffset*0.4), sprintf('p = %.4f', p), 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'k');
            % Draw the bracket
            line([i, i, j, j], [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], 'Color', 'k', 'linewidth', 1.25);
            % comparisonCount = comparisonCount + 1;
        end
    end

    % Adjust y-axis limits to ensure all annotations are visible
    YBotLim = min(minValues)-min(minValues)*0.5 ; 
    YTopLim = max(maxValues)+yOffset*(numComparisons) ; 
    ylim([YBotLim YTopLim]);
    
    % Customize the plot
    xlim([0.5, numCategories + 0.5]);
    xticks(1:numCategories);


end
