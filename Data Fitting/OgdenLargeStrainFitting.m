function [FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting(InitialGuess, Stress, Strain)
    % Set Up the Solver
    problem.options = optimoptions('lsqnonlin', 'Display', 'iter', ...
        'Algorithm', 'trust-region-reflective', ...
        'MaxFunctionEvaluations', 5000, 'FunctionTolerance', 1e-8);
    problem.objective = @(x) OgdenEquations(x, [], Stress, Strain);
    problem.x0 = InitialGuess;
    problem.solver = 'lsqnonlin';
    
    % Solve
    FittingValues = lsqnonlin(problem);
    
    % Generate fitted stress values
    mu = FittingValues(1:2:end);
    alpha = FittingValues(2:2:end);
    StressFit = arrayfun(@(e) sum(mu .* ((1 + e).^(alpha - 1) - (1 + e).^(-alpha - 1))), Strain);
    
    % Plot results
    plot(Strain, Stress, '-b', 'LineWidth', 2); hold on;
    plot(Strain, StressFit, '--r', 'LineWidth', 2);
    legend('Experimental', 'Ogden Fit');
    hold off;
    
    % Calculate goodness of fit metrics
    residuals = Stress - StressFit;
    SS_res = sum(residuals.^2);
    SS_tot = sum((Stress - mean(Stress)).^2);
    r_squared = 1 - (SS_res / SS_tot);
    rmse = sqrt(mean(residuals.^2));
    
    GoodnessOfFit = [r_squared, rmse];
end