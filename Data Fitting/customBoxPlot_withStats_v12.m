function customBoxPlot_withStats_v12(dataCell, originalDataCell)

% Check input
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

numCategories = length(dataCell);
maxValues = zeros(1, numCategories);
minValues = zeros(1, numCategories);
LineWidthVal = 2;

% --- Plotting Loop ---
for n = 1:numCategories
    Data = dataCell{n};
    Data = Data(~isnan(Data));

    if isempty(Data)
        continue;
    end

    % Stats for box
    meanValue = mean(Data);
    stdDev = std(Data);
    minValue = min(Data);
    maxValue = max(Data);
    maxValues(n) = maxValue;
    minValues(n) = minValue;

    boxBottom = meanValue - stdDev;
    boxTop = meanValue + stdDev;
    boxwidth = 0.35;

    % Whiskers
    if boxBottom > minValue && boxTop < maxValue
        plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', LineWidthVal); hold on;
        plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', LineWidthVal);
        plot([n - boxwidth/4, n + boxwidth/4], [maxValue, maxValue], 'k-', 'LineWidth', LineWidthVal);
        plot([n - boxwidth/4, n + boxwidth/4], [minValue, minValue], 'k-', 'LineWidth', LineWidthVal);
    end

    % Box and mean line
    fill([n - boxwidth/2, n + boxwidth/2, n + boxwidth/2, n - boxwidth/2], ...
         [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', LineWidthVal);
    plot([n - boxwidth/2, n + boxwidth/2], [meanValue, meanValue], 'r-', 'LineWidth', LineWidthVal);

    % Data points
    numPoints = length(Data);
    x = (n - boxwidth/4) + (boxwidth/2)*rand(numPoints, 1);
    plot(x, Data, 'bo', 'MarkerSize', 4, 'MarkerFaceColor', 'b');

    % --- Label mean using original data if provided ---
    if nargin > 1 && ~isempty(originalDataCell) && ~isempty(originalDataCell{n})
        Original = originalDataCell{n};
        Original = Original(~isnan(Original));
        displayMean = mean(Original);  % arithmetic mean in linear space
    else
        displayMean = mean(Data);  % fallback
    end

    % Annotation
    text(n + boxwidth/1.4, meanValue, sprintf('%.2f', displayMean), ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');
end

% --- Significance Testing ---
yOffset = max(maxValues) * 0.1;
compCount = 1;

for i = 1:numCategories
    for j = i+1:numCategories
        [~, p] = ttest2(dataCell{i}, dataCell{j});

        if p < 0.05
            if p < 0.001
                sigStars = '***';
            elseif p < 0.01
                sigStars = '**';
            else
                sigStars = '*';
            end

            comparisonCount = abs(i - j);
            if comparisonCount > 1
                compCount = compCount + 1;
                comparisonCount = compCount;
            end

            xPos = (i + j) / 2;
            yPos = max(maxValues) + yOffset * comparisonCount;

            % text(xPos, yPos + yOffset * 0.4, sigStars, ...
            %     'HorizontalAlignment', 'center', 'FontSize', 24, 'FontWeight', 'bold', 'Color', 'k');
            % 
            % line([i, i, j, j], ...
            %      [yPos - yOffset/4, yPos, yPos, yPos - yOffset/4], ...
            %      'Color', 'k', 'LineWidth', LineWidthVal);

            compCount = compCount + 1;
        end
    end
end

% Axis Settings
YBotLim = min(minValues) - abs(min(minValues)) * 1;
YTopLim = max(maxValues) + yOffset * (compCount + 1);
ylim([YBotLim YTopLim]);

xlim([0.5, numCategories + 0.5]);
xticks(1:numCategories);

end