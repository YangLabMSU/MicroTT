function customBoxPlot_v2(data)

NumVectors = size(data, 2) ; 

for n = 1:NumVectors

    Data = data(:, n) ;
    Data = Data(~isnan(Data)) ;

    % Calculate necessary statistics
    meanValue = mean(Data);
    stdDev = std(Data);
    minValue = min(Data);
    maxValue = max(Data);
    
    % Define the box boundaries
    boxBottom = meanValue - stdDev;
    boxTop = meanValue + stdDev;
   
    % Plot the whiskers
    plot([n, n], [minValue, boxBottom], 'k--', 'LineWidth', 1.25); hold on ; 
    plot([n, n], [boxTop, maxValue], 'k--', 'LineWidth', 1.25);
    
    % Plot the box
    boxwidth = 0.35 ; 
    fill([n - (boxwidth/2), n + (boxwidth/2), n + (boxwidth/2), n - (boxwidth/2)], [boxBottom, boxBottom, boxTop, boxTop], 'b', 'FaceAlpha', 0.1, 'LineWidth', 1.25);
    
    % Plot the average line
    plot([n - (boxwidth/2), n + (boxwidth/2)], [meanValue, meanValue], 'r-', 'LineWidth', 2);
    plot([n - (boxwidth/4), n + (boxwidth/4)], [maxValue, maxValue], 'k-', 'LineWidth', 1.25) ; 
    plot([n - (boxwidth/4), n + (boxwidth/4)], [minValue, minValue], 'k-', 'LineWidth', 1.25) ; 
    
    % Overlay the data points
    numPoints = length(Data);
    x = (n - (boxwidth/4)) + ( (n + (boxwidth/4)) - (n - (boxwidth/4)) ) * rand(numPoints, 1) ;
    plot(x, Data, 'b.', 'MarkerSize', 6); 

    % Label the average value
    text(n + (boxwidth/1.2), meanValue-(meanValue*0.02), sprintf('%.2f', meanValue), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');


end

    xlim([0.5, NumVectors+0.5]);
    xticks(1:NumVectors);

end


