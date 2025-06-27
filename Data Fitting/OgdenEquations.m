function F = OgdenEquations(x, PV, Stress, Strain)
    % Ogden material model equations for fitting
    mu = x(1:2:end); % Odd indices: mu1, mu2, ...
    alpha = x(2:2:end); % Even indices: alpha1, alpha2, ...
    
    % Loop through data points to compute stress differences
    F = zeros(size(Strain));
    for i = 1:length(Strain)
        lambda = 1 + Strain(i); % Stretch ratio
        stress_pred = sum(mu .* (lambda.^(alpha - 1) - lambda.^(-alpha - 1)));
        F(i) = stress_pred - Stress(i);
    end
end
