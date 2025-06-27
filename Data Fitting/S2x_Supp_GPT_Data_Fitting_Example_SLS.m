clear ; clc ; close ; 

% Curve Fitting with GPT - v2
% GPT Example of Model
load('All Stretch Experiment Data.mat') ; 
strain_data = (StretchExperimentData{1,3})' ; 
stress_data = (StretchExperimentData{1,2})' ; 

% Initial guess for parameters [E1, E2, tau1, tau2]
initial_guess = [1, 1, 1, 1];

% Define the objective function
objective_function = @(params, epsilon) sls_model(params, epsilon) - stress_data;

% Perform the curve fitting
options = optimset('Display', 'off');
fitted_params = lsqcurvefit(objective_function, initial_guess, strain_data, stress_data, [], [], options);

% Display the fitted parameters
disp('Fitted parameters:');
disp(['E1: ', num2str(fitted_params(1))]);
disp(['E2: ', num2str(fitted_params(2))]);
disp(['tau1: ', num2str(fitted_params(3))]);
disp(['tau2: ', num2str(fitted_params(4))]);

% Plot the results
fitted_stress = sls_model(fitted_params, strain_data);

figure;
plot(strain_data, stress_data, 'bo', 'DisplayName', 'Original Data');
hold on;
plot(strain_data, fitted_stress, 'r-', 'DisplayName', 'Fitted Model');
xlabel('Strain');
ylabel('Stress');
legend('show');
title('SLS Model Fitting');

