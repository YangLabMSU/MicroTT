function residuals = computeResiduals_v2(params, lambda, NormalizedStress)
    % Computes residuals between normalized model and experimental stress
    % Inputs:
    %   params - Current parameter guess [mu1, alpha1, mu2, alpha2, ...]
    %   lambda - Stretch ratio
    %   NormalizedStress - Normalized experimental stress data
    % Output:
    %   residuals - Difference between normalized model and experimental stress

    % Compute model stress
    modelStress = computeOgdenUniaxialStress(params, lambda);

    % Normalize model stress (using max of experimental stress)
    modelStress = modelStress / max(modelStress);

    % Compute residuals
    residuals = modelStress - NormalizedStress;
end
