clear; clc; close all;

% GPT Example of Model
load('All Stretch Experiment Data.mat') ; 
strain = StretchExperimentData{1,3} ; 
stress = StretchExperimentData{1,2} ; 

% Define the piecewise model function with coefficients before the independent variable
model = @(E, sigma_y, K, n, strain) (strain <= sigma_y/E) .* E .* strain + ...
                                    (strain > sigma_y/E) .* (sigma_y + K .* (strain - sigma_y/E).^n);

% Create a fit type with the custom model
ft = fittype(model, 'independent', 'strain', 'coefficients', {'E', 'sigma_y', 'K', 'n'});

% Initial guess for the parameters
initial_guess = [2000, 50, 10, 0.2];

% Fit the noisy data using the defined workflow
fit_result = fit(strain, stress, ft, 'StartPoint', initial_guess);

% Extract the fitted parameters and plot
E = fit_result.E;
sigma_y = fit_result.sigma_y;
K = fit_result.K;
n = fit_result.n;
fitted_stress = model(E, sigma_y, K, n, strain);

figure;
plot(strain, stress, 'o', 'DisplayName', 'Noisy Data');
hold on;
plot(strain, fitted_stress, '-', 'DisplayName', 'Fitted Model');
xlabel('Strain');
ylabel('Stress');
legend;
title('Stress-Strain Curve Fitting with Synthetic Data');
hold off;

% Calculate and display goodness of fit metrics
residuals = stress - fitted_stress;
SS_res = sum(residuals.^2);
SS_tot = sum((stress - mean(stress)).^2);
r_squared = 1 - (SS_res / SS_tot);
rmse = sqrt(mean(residuals.^2));

disp(['R-squared: ', num2str(r_squared)]);
disp(['RMSE: ', num2str(rmse)]);
