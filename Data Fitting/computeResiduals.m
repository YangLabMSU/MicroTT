function residuals = computeResiduals(params, lambda, Stress)
    % Computes the residuals between model and experimental stress
    % Inputs:
    %   params - Current parameter guess [mu1, alpha1, mu2, alpha2, ...]
    %   lambda - Stretch ratio (1 + strain)
    %   Stress - Experimental stress data
    % Output:
    %   residuals - Difference between model and experimental stress

    % Compute model stress
    modelStress = computeOgdenUniaxialStress(params, lambda);

    % Compute residuals
    residuals = modelStress - Stress;
    
end
