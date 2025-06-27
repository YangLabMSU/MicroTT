function OgdenModelUniaxialInteractive()
% Ogden Model Interactive with Sliders for N=3 (Dynamic Parameter Display)
clear; clc; close all;

% Load data
load("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat");

% Select a specific dataset to fit
Stress = StretchExperimentData{2, 2};
Strain = StretchExperimentData{2, 3};
lambda = 1 + Strain; % Stretch ratio

% Define strain range and initial stretch ratios
strain = linspace(0, 1, 100); % Strain from 0 to 1
lambda = 1 + strain; % Stretch ratio

% Initial parameters [mu1, alpha1, mu2, alpha2, mu3, alpha3]
initialParams = [1500, -3.67, 37.3, -5, -1311.1, -0.5]; % Example values

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

% Create sliders and text boxes dynamically for each parameter
for i = 1:handles.numTerms
    % Mu sliders
    uicontrol('Style', 'slider', 'Min', -2000, 'Max', 2000, ...
        'Value', initialParams(2*i - 1), ...
        'Position', [50, 50 + (i-1)*50, 200, 20], ...
        'Callback', @(src, ~) updateCurve(src, 2*i - 1));
    uicontrol('Style', 'text', 'String', sprintf('Mu%d', i), ...
        'Position', [10, 50 + (i-1)*50, 40, 20]);
    handles.muText(i) = uicontrol('Style', 'text', ...
        'String', sprintf('%.1f', initialParams(2*i - 1)), ...
        'Position', [50, 30 + (i-1)*50, 200, 20]);

    % Alpha sliders
    uicontrol('Style', 'slider', 'Min', -7.5, 'Max', 7.5, ...
        'Value', initialParams(2*i), ...
        'Position', [300, 50 + (i-1)*50, 200, 20], ...
        'Callback', @(src, ~) updateCurve(src, 2*i));
    uicontrol('Style', 'text', 'String', sprintf('Alpha%d', i), ...
        'Position', [260, 50 + (i-1)*50, 40, 20]);
    handles.alphaText(i) = uicontrol('Style', 'text', ...
        'String', sprintf('%.2f', initialParams(2*i)), ...
        'Position', [300, 30 + (i-1)*50, 200, 20]);
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

% Function to update the curve and display updated parameter values
function updateCurve(src, paramIdx)
% Retrieve handles
hFig = ancestor(src, 'figure');
handles = guidata(hFig);

% Update parameter based on slider value
handles.params(paramIdx) = src.Value;

% Update corresponding text box
if mod(paramIdx, 2) == 1 % Mu parameter
    set(handles.muText((paramIdx + 1)/2), 'String', sprintf('%.1f', src.Value));
else % Alpha parameter
    set(handles.alphaText(paramIdx/2), 'String', sprintf('%.2f', src.Value));
end

% Recompute and update plot
stress = computeOgdenUniaxialStress(handles.params, handles.lambda);
handles.hPlot.YData = stress;

% Save updated handles
guidata(hFig, handles);
end
