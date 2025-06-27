function OgdenModelUniaxialInteractive()
    % Ogden Model Interactive with Sliders for N=3
    clear; clc; close all;

    % Define strain range and initial stretch ratios
    strain = linspace(0, 1, 100); % Strain from 0 to 1
    lambda = 1 + strain; % Stretch ratio

    % Initial parameters [mu1, alpha1, mu2, alpha2, mu3, alpha3]
    initialParams = [5.3, 0.0018, 0.0091, -2, 0.39, 1.4]; % Example values

    % Create figure
    hFig = figure('Name', 'Ogden Model Interactive (N=3)', 'NumberTitle', 'off', ...
                  'Position', [100, 100, 800, 600]);

    % Axes for plotting
    hAxes = axes('Parent', hFig, 'Position', [0.1, 0.4, 0.8, 0.55]);
    hPlot = plot(hAxes, strain, computeOgdenUniaxialStress(initialParams, lambda), '-b', 'LineWidth', 2);
    grid on;
    title(hAxes, 'Ogden Model Uniaxial Stress-Strain Curve (N=3)');
    xlabel(hAxes, 'Strain');
    ylabel(hAxes, 'Stress');
    legend(hAxes, 'Ogden Model Fit');

    % Store variables in handles
    handles = struct();
    handles.strain = strain;
    handles.lambda = lambda;
    handles.params = initialParams;
    handles.hPlot = hPlot;
    handles.numTerms = length(initialParams) / 2;

    % Create sliders dynamically for each parameter
    for i = 1:handles.numTerms
        % Mu sliders
        uicontrol('Style', 'slider', 'Min', -1000, 'Max', 1000, ...
            'Value', initialParams(2*i - 1), ...
            'Position', [50, 50 + (i-1)*50, 200, 20], ...
            'Callback', @(src, ~) updateCurve(src, 2*i - 1));
        uicontrol('Style', 'text', 'String', sprintf('Mu%d', i), ...
            'Position', [10, 50 + (i-1)*50, 40, 20]);

        % Alpha sliders
        uicontrol('Style', 'slider', 'Min', -5, 'Max', 5, ...
            'Value', initialParams(2*i), ...
            'Position', [300, 50 + (i-1)*50, 200, 20], ...
            'Callback', @(src, ~) updateCurve(src, 2*i));
        uicontrol('Style', 'text', 'String', sprintf('Alpha%d', i), ...
            'Position', [260, 50 + (i-1)*50, 40, 20]);
    end

    % Save handles using guidata
    guidata(hFig, handles);
end

% Function to compute uniaxial stress
function stress = computeOgdenUniaxialStress(params, lambda)
    % Computes the uniaxial stress for N=3 using the Ogden model
    % Inputs:
    %   params - Vector [mu1, alpha1, mu2, alpha2, mu3, alpha3]
    %   lambda - Stretch ratios (1 + strain)
    % Output:
    %   stress - Computed uniaxial stress

    % Extract parameters
    mu = params(1:2:end);     % Odd indices: mu_k
    alpha = params(2:2:end);  % Even indices: alpha_k

    % Initialize stress
    stress = zeros(size(lambda));

    % Compute stress for each term
    for k = 1:length(mu)
        stress = stress + (2 * mu(k) / alpha(k)) .* ...
                 (lambda.^alpha(k) - (1 ./ sqrt(lambda)).^alpha(k));
    end
end

% Function to update the curve
function updateCurve(src, paramIdx)
    % Retrieve handles
    hFig = ancestor(src, 'figure');
    handles = guidata(hFig);

    % Update parameter based on slider value
    handles.params(paramIdx) = src.Value;

    % Recompute and update plot
    stress = computeOgdenUniaxialStress(handles.params, handles.lambda);
    handles.hPlot.YData = stress;

    % Save updated handles
    guidata(hFig, handles);
end
