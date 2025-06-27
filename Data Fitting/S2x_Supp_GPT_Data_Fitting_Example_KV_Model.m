clear; clc; close all;

% GPT Example of Model
load('All Stretch Experiment Data.mat') ; 
strain = StretchExperimentData{1,3} ; 
stress = StretchExperimentData{1,2} ; 

% Define the Kelvin-Voigt model function
kv_model = @(E, eta, strain) E * strain + eta * [0; diff(strain)];

% Create a fit type with the custom model
ft = fittype(kv_model, 'independent', 'strain', 'coefficients', {'E', 'eta'});

% Initial guess for the parameters
initial_guess = [2000, 10]; % Adjust based on your data

% Fit the experimental data using the defined model
fit_result = fit(strain, stress, ft, 'StartPoint', initial_guess);

% Extract the fitted parameters
E = fit_result.E;
eta = fit_result.eta;

% Generate the fitted stress values
fitted_stress = kv_model(E, eta, strain);

% Plot the experimental data and the fit
figure;
plot(strain, stress, 'o', 'DisplayName', 'Experimental Data');
hold on;
plot(strain, fitted_stress, '-', 'DisplayName', 'Fitted Model');
xlabel('Strain');
ylabel('Stress');
legend;
title('Stress-Strain Curve Fitting with Kelvin-Voigt Model');
hold off;

% Calculate and display goodness of fit metrics
residuals = stress - fitted_stress;
SS_res = sum(residuals.^2);
SS_tot = sum((stress - mean(stress)).^2);
r_squared = 1 - (SS_res / SS_tot);
rmse = sqrt(mean(residuals.^2));

disp(['R-squared: ', num2str(r_squared)]);
disp(['RMSE: ', num2str(rmse)]);
