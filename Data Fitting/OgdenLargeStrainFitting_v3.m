function [FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting_v3(InitialGuess, NormalizedStress, lambda)
    % Ogden Model Fitting with Normalized Data
    
    % Inputs:
    %   InitialGuess - Initial parameter guesses [mu1, alpha1, mu2, alpha2, ...]
    %   NormalizedStress - Normalized experimental stress data
    %   lambda - Stretch ratio (1 + strain)
    % Outputs:
    %   FittingValues - Fitted parameters [mu1, alpha1, mu2, alpha2, ...]
    %   GoodnessOfFit - Metrics [R^2, RMSE]

    % Options for nonlinear fitting
    options = optimoptions('lsqnonlin', 'Display', 'iter', ...
        'MaxFunctionEvaluations', 5000, 'FunctionTolerance', 1e-8);

    % Objective function: residuals between normalized experimental and model stress
    objective = @(params) computeResiduals_v2(params, lambda, NormalizedStress);

    % Perform fitting
    [FittingValues, ~, residuals] = lsqnonlin(objective, InitialGuess, [], [], options);

    % Compute normalized fitted stress
    FittedStress = computeOgdenUniaxialStress(FittingValues, lambda);

    % Goodness of Fit Metrics (on normalized data)
    SS_res = sum(residuals.^2); % Sum of squared residuals
    SS_tot = sum((NormalizedStress - mean(NormalizedStress)).^2); % Total sum of squares
    R_squared = 1 - (SS_res / SS_tot); % Coefficient of determination
    RMSE = sqrt(mean(residuals.^2)); % Root Mean Squared Error
    GoodnessOfFit = [R_squared, RMSE];
end
