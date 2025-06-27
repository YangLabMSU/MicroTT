function customDashedLine(x, y, dashLength, gapLength, lineWidth, lineColor)
    % customDashedLine: Plots a customized dashed line
    %
    % Inputs:
    %   x           - Vector of x values
    %   y           - Vector of y values
    %   dashLength  - Length of each dash (in data units)
    %   gapLength   - Length of each gap between dashes (in data units)
    %   lineWidth   - Width of the line
    %   lineColor   - Color of the line (can be a color string or RGB array)
    %
    % Example usage:
    %   customDashedLine(0:0.1:10, sin(0:0.1:10), 0.5, 0.2, 2, 'r')

    hold on;
    
    % Make sure x and y are column vectors
    x = x(:);
    y = y(:);

    % Calculate the total number of segments based on dash and gap length
    totalLength = sqrt(diff(x).^2 + diff(y).^2); % Distance between each point
    cumulativeLength = [0; cumsum(totalLength)]; % Cumulative length from start

    % Create the dashed pattern
    currentPosition = 0;  % Start at the beginning of the data
    index = 1;  % Start from the first point
    
    % Plot dashes one by one
    while currentPosition < cumulativeLength(end)
        % Find the start of the dash
        while cumulativeLength(index) < currentPosition && index < length(x)
            index = index + 1;
        end
        if index >= length(x)
            break;
        end
        % Start dash at current index
        startPoint = [x(index), y(index)];
        
        % Find end of dash
        endPosition = currentPosition + dashLength;  % Dash end position
        while index < length(x) && cumulativeLength(index) < endPosition
            index = index + 1;
        end
        if index >= length(x)
            endPoint = [x(end), y(end)];
        else
            fraction = (endPosition - cumulativeLength(index-1)) / totalLength(index-1);
            endPoint = [x(index-1), y(index-1)] + fraction * ([x(index), y(index)] - [x(index-1), y(index-1)]);
        end
        
        % Plot the dash
        plot([startPoint(1), endPoint(1)], [startPoint(2), endPoint(2)], ...
            'Color', lineColor, 'LineWidth', lineWidth);
        
        % Move the current position to the end of the gap after the dash
        currentPosition = endPosition + gapLength;
    end
    
    hold off;
end
