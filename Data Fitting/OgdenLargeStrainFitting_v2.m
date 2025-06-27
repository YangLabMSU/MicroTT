function [FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting_v2(InitialGuess, Stress, lambda)

    % Ogden Model Fitting using lsqnonlin
    % Inputs:
    %   InitialGuess - Initial parameter guesses [mu1, alpha1, mu2, alpha2, ...]
    %   Stress - Experimental stress data
    %   lambda - Stretch ratio (1 + strain)
    % Outputs:
    %   FittingValues - Fitted parameters [mu1, alpha1, mu2, alpha2, ...]
    %   GoodnessOfFit - Metrics [R^2, RMSE]

    % Options for nonlinear fitting
    options = optimoptions('lsqnonlin', 'Display', 'iter', ...
        'MaxFunctionEvaluations', 10000, 'MaxIterations', 10000, 'FunctionTolerance', 1e-18,...
        'StepTolerance', 1e-15); %

    % Objective function: residuals between experimental and model stress
    objective = @(params) computeResiduals(params, lambda, Stress);

    % Perform fitting
    [FittingValues, ~, residuals] = lsqnonlin(objective, InitialGuess, [], [], options);

    % Compute fitted stress values
    FittedStress = computeOgdenUniaxialStress(FittingValues, lambda);

    % Goodness of Fit Metrics
    SS_res = sum(residuals.^2); % Sum of squared residuals
    SS_tot = sum((Stress - mean(Stress)).^2); % Total sum of squares
    R_squared = 1 - (SS_res / SS_tot); % Coefficient of determination
    RMSE = sqrt(mean(residuals.^2)); % Root Mean Squared Error
    GoodnessOfFit = [R_squared, RMSE];

    % % Plot results
    % figure;
    % plot(lambda - 1, Stress, '-b', 'LineWidth', 2); hold on;
    % plot(lambda - 1, FittedStress, '--r', 'LineWidth', 2);
    % grid on;
    % title('Ogden Model Curve Fitting (N=2)');
    % xlabel('Strain');
    % ylabel('Stress');
    % legend('Experimental Data', 'Fitted Model');
    % hold off;
end
