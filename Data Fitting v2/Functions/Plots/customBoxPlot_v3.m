function customBoxPlot_v3(dataCell)

% Check if dataCell is a cell array
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

% Number of categories
numCategories = length(dataCell);

for n = 1:numCategories
    Data = dataCell{n};

    % Calculate necessary statistics
    meanValue = mean(Data);
    stdDev = std(Data);
    minValue = min(Data);
    maxValue = max(Data);

    % Define the box boundaries
    boxBottom = meanValue - stdDev;
    boxTop = meanValue + stdDev;

    % Plot the box
    boxwidth = 0.35 ;


    % Plot the whiskers
    if boxBottom > minValue && boxTop < maxValue
        plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', 1.25); hold on ;
        plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', 1.25);
        plot([n - (boxwidth/4), n + (boxwidth/4)], [maxValue, maxValue], 'k-', 'LineWidth', 1.25) ;
        plot([n - (boxwidth/4), n + (boxwidth/4)], [minValue, minValue], 'k-', 'LineWidth', 1.25) ;
    end

    fill([n - (boxwidth/2), n + (boxwidth/2), n + (boxwidth/2), n - (boxwidth/2)], [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', 1.25); hold on ;

    % Plot the average line
    plot([n - (boxwidth/2), n + (boxwidth/2)], [meanValue, meanValue], 'r-', 'LineWidth', 2);

    % Overlay the data points
    numPoints = length(Data);
    x = (n - (boxwidth/4)) + ( (n + (boxwidth/4)) - (n - (boxwidth/4)) ) * rand(numPoints, 1) ;
    plot(x, Data, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

    % Label the average value
    text(n + (boxwidth/1.1), meanValue, sprintf('%.2f', meanValue), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');

end



xlim([0.5, numCategories+0.5]) ;
xticks(1:numCategories) ;

end
