clear ; clc ; close ; 

% Data
% Load data
load("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat");

% Select a specific dataset to fit
Stress = StretchExperimentData{2, 2};
Strain = StretchExperimentData{2, 3};
plot(Strain, Stress, '-r', 'linewidth', 3) ; hold on ; 

% Define strain range and initial stretch ratios
strain = linspace(0, 1, 100); % Strain from 0 to 1
lambda = 1 + strain; % Stretch ratio

% Initial parameters [mu1, alpha1, mu2, alpha2, mu3, alpha3]
%initialParams = [701.3955  -21.1822   -0.0000 -133.1734 -337.9074   10.6811]; % Example values
initialParams = [701.3955  -21.1822  -337.9074   10.6811];

% Extract parameters
mu = initialParams(1:2:end);     % Odd indices: mu_k
alpha = initialParams(2:2:end);  % Even indices: alpha_k

% Initialize stress
stress = zeros(size(lambda));

% Compute stress for each term
for k = 1:length(mu)
    stress = stress + (2 * mu(k) / alpha(k)) .* ...
        (lambda.^alpha(k) - (1 ./ sqrt(lambda)).^alpha(k));
end

plot(strain, stress, '-b', 'linewidth', 2) ; 


