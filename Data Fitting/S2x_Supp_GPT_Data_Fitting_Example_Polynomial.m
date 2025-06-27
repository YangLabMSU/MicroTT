clear ; clc ; close ; 

% GPT Example of Model
load('All Stretch Experiment Data.mat') ; 
strain_data = StretchExperimentData{1,3} ; 
stress_data = StretchExperimentData{1,2} ; 
 
% Perform polynomial curve fitting
poly_degree = 6; % Degree of the polynomial
p = polyfit(strain_data, stress_data, poly_degree);

% Evaluate the polynomial at x values
y_fit = polyval(p, strain_data);

% Plot the results
figure;
plot(strain_data, stress_data, 'bo', 'DisplayName', 'Original Data');
hold on;
plot(strain_data, y_fit, 'r-', 'DisplayName', 'Polynomial Fit', 'linewidth', 3);
xlabel('x');
ylabel('y');
legend('show');
title('3-Term Polynomial Curve Fitting');

