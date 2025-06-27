function OgdenModelInteractive()
    % Ogden Model Interactive Script
    clear; clc; close all;

    % Define strain range (can be adjusted as needed)
    strain = linspace(0, 1, 500); % Strain from 0 to 1

    % Initial parameters for the Ogden Model
    % Format: [mu1, alpha1, mu2, alpha2, ...]
    initialParams = [1500, 2, 600, 1.5]; % Example values

    % Create figure for visualization
    hFig = figure('Name', 'Ogden Model Interactive', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Axes for plotting
    hAxes = axes('Parent', hFig, 'Position', [0.1, 0.4, 0.8, 0.55]);
    hPlot = plot(hAxes, strain, computeOgdenStress(initialParams, strain), '-b', 'LineWidth', 2);
    grid on;
    title(hAxes, 'Ogden Model Stress-Strain Curve');
    xlabel(hAxes, 'Strain');
    ylabel(hAxes, 'Stress');
    legend(hAxes, 'Ogden Model Fit');

    % Store variables in handles
    handles = struct();
    handles.strain = strain;
    handles.params = initialParams;
    handles.hPlot = hPlot;
    handles.numTerms = length(initialParams) / 2;

    % Create sliders dynamically for each parameter
    for i = 1:handles.numTerms
        % Mu sliders
        uicontrol('Style', 'slider', 'Min', 0, 'Max', 5000, ...
            'Value', initialParams(2*i - 1), ...
            'Position', [50, 50 + (i-1)*30, 200, 20], ...
            'Callback', @(src, ~) updateCurve(src, 2*i - 1));
        uicontrol('Style', 'text', 'String', sprintf('Mu%d', i), ...
            'Position', [10, 50 + (i-1)*30, 40, 20]);

        % Alpha sliders
        uicontrol('Style', 'slider', 'Min', 0.01, 'Max', 5, ...
            'Value', initialParams(2*i), ...
            'Position', [300, 50 + (i-1)*30, 200, 20], ...
            'Callback', @(src, ~) updateCurve(src, 2*i));
        uicontrol('Style', 'text', 'String', sprintf('Alpha%d', i), ...
            'Position', [260, 50 + (i-1)*30, 40, 20]);
    end

    % Save handles using guidata
    guidata(hFig, handles);
end

% Function to compute Ogden stress
function stress = computeOgdenStress(params, strain)
    stress = arrayfun(@(e) sum(params(1:2:end) .* ((1 + e).^(params(2:2:end) - 1) - (1 + e).^(-params(2:2:end) - 1))), strain);
end

% Function to update the curve
function updateCurve(src, paramIdx)
    % Retrieve handles
    hFig = ancestor(src, 'figure');
    handles = guidata(hFig);

    % Update parameter based on slider value
    handles.params(paramIdx) = src.Value;

    % Recompute and update plot
    stress = computeOgdenStress(handles.params, handles.strain);
    handles.hPlot.YData = stress;

    % Save updated handles
    guidata(hFig, handles);
end
