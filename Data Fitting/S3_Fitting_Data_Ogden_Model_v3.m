clear; clc; close all; 
% Ogden Fitting - Main Script with Scaling and Normalization

% Load data
load("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat");

% Select a specific dataset to fit
Stress = StretchExperimentData{1, 2};
Strain = StretchExperimentData{1, 3};
lambda = 1 + Strain; % Stretch ratio

% Normalize data
StressMax = max(Stress);
StrainMax = max(Strain);
NormalizedStress = Stress / StressMax;
NormalizedStrain = Strain / StrainMax;

% Initial guesses [mu1, alpha1, mu2, alpha2, mu3, alpha3]
InitialGuess = [6587, -1.91, 1817, -4.31, -7825, -1.02]; % Scaled for magnitude

% Perform fitting with normalized data
[FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting_v3(InitialGuess, NormalizedStress, lambda);

% Denormalize fitted stress for plotting
FittedStress = computeOgdenUniaxialStress(FittingValues, lambda) ; %* StressMax;

% Display results
disp("Fitted Parameters:");
disp(FittingValues);
disp("Goodness of Fit:");
disp(GoodnessOfFit);

% Plot results
figure;
plot(Strain, Stress, '-b', 'LineWidth', 2); hold on;
plot(Strain, FittedStress, '--r', 'LineWidth', 2);
grid on;
title('Ogden Model Curve Fitting (N=3) with Scaling and Normalization');
xlabel('Strain');
ylabel('Stress');
legend('Experimental Data', 'Fitted Model');
hold off;
