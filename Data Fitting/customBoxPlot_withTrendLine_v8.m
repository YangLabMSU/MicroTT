function customBoxPlot_withTrendLine_v8(dataCell)

% Check if dataCell is a cell array
if ~iscell(dataCell)
    error('Input dataCell must be a cell array');
end

% Number of categories
numCategories = length(dataCell);

% Initialize arrays for maxValues and trend data
maxValues = zeros(1, numCategories);
trendData = zeros(1, numCategories);

% Calculate statistics and prepare for box plot
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
        trendData(n) = meanValue; % Use mean for trend line
        
        % Define the box boundaries
        boxBottom = meanValue - stdDev;
        boxTop = meanValue + stdDev;

        % Plot the whiskers
        if boxBottom > minValue && boxTop < maxValue
            plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', 2); hold on;
            plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', 2);
        end

        % Plot the box
        boxwidth = 0.5;
        rectangle('Position', [n - boxwidth / 2, boxBottom, boxwidth, 2 * stdDev], ...
                  'EdgeColor', 'b', 'LineWidth', 2);
    end
end

% Plot trend line behind box plots

plot(1:numCategories, trendData, 'r-', 'LineWidth', 2, 'DisplayName', 'Trend Line'); hold on;

% Set axis properties
xlabel('Categories');
ylabel('Values');
title('Custom Box Plot with Trend Line');
legend show;
grid on;

hold off;

end
