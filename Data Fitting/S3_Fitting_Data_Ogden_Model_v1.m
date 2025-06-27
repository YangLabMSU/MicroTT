clear; clc; close all;
% Ogden Fitting - Main Script - v1

% Load data
load("Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat");

% Select a specific dataset to fit
Stress = StretchExperimentData{1, 2};
Strain = StretchExperimentData{1, 3};

% Initial guesses [mu1, alpha1, mu2, alpha2, ...]
InitialGuess = [1e3, 2, 5e2, 1.5];

% Perform fitting
[FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting(InitialGuess, Stress, Strain);

% Display results
disp("Fitted Parameters:");
disp(FittingValues);
disp("Goodness of Fit:");
disp(GoodnessOfFit);
