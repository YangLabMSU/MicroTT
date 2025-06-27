clear ; clc ; close ; 

% GPT Example of Model
load('All Stretch Experiment Data.mat') ; 
strain_data = StretchExperimentData{1,3} ; 
stress_data = StretchExperimentData{1,2} ; 

% Curve Fitting the Stretch Experiments - grayson model
% Initial guess for parameters [E1, E2, E3, Lam1, Lam2]
%initial_guess = [1, 1, 1, 1, 1];
initial_guess = [ 1000 475 0.2 1700 1.05 ] ;
% Define the objective function
objective_function = @(params, epsilon) grayson_polymer_model(params, epsilon) - stress_data;

% Perform the curve fitting
options = optimset('Display', 'off');
fitted_params = lsqcurvefit(objective_function, initial_guess, strain_data, stress_data, [], [], options);

% Display the fitted parameters
disp('Fitted parameters:');
disp(['E1: ', num2str(fitted_params(1))]);
disp(['E2: ', num2str(fitted_params(2))]);
disp(['E3: ', num2str(fitted_params(3))]);
disp(['Lam1: ', num2str(fitted_params(4))]);
disp(['Lam2: ', num2str(fitted_params(5))]);

% Plot the results
fitted_stress = grayson_polymer_model(fitted_params, strain_data);

figure;
plot(strain_data, stress_data, 'bo', 'DisplayName', 'Original Data');
hold on;
plot(strain_data, fitted_stress, 'r-', 'DisplayName', 'Fitted Model');
xlabel('Strain');
ylabel('Stress');
legend('show');
title('Custom Model Fitting');
