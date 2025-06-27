function [FittingValues, GoodnessOfFit] = TPPTT_LargeStrainFittingFunc_v2(InitialGuess, FitParameters, Stress, Strain) 

% Initial Guesses at X
E1 = FitParameters(1) ; 
x0 = InitialGuess ;

% Set Up the Solver
problem.options = optimoptions('fsolve','Display','none', 'Algorithm', 'Levenberg-Marquardt', 'MaxFunctionEvaluations', 5000, 'FunctionTolerance', 1e-10, 'StepTolerance', 1e-3) ; % , 'PlotFcn', @optimplotfirstorderopt);
problem.objective = @(x)PolymerEquations_v2(x, FitParameters, Stress, Strain) ;
problem.x0 = x0 ;
problem.solver = 'fsolve' ; 

% Solve
x = fsolve(problem) ; 

StrainFit = abs(Strain) ; %linspace(0, Strain(end), 100) ; 
StressFit = x(1).*StrainFit - x(2)*exp(-(x(3)./StrainFit)) - x(4)*exp(-(x(5)./StrainFit)) ; 
plot(StrainFit, StressFit, '-.g','LineWidth', 2) ;

FittingValues = x ;

% Calculate and display goodness of fit metrics
residuals = Stress - StressFit ;
SS_res = sum(residuals.^2);
SS_tot = sum((Stress - mean(Stress)).^2);
r_squared = 1 - (SS_res / SS_tot);
rmse = sqrt(mean(residuals.^2));

GoodnessOfFit = [ r_squared, rmse ] ; 

end
