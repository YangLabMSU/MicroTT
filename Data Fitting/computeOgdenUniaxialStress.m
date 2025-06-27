function stress = computeOgdenUniaxialStress(params, lambda)
    % Computes the uniaxial stress for the Ogden model
    % Inputs:
    %   params - Vector [mu1, alpha1, mu2, alpha2, ...]
    %   lambda - Stretch ratio (1 + strain)
    % Output:
    %   stress - Computed uniaxial stress

    % Extract parameters
    mu = params(1:2:end);     % Odd indices: mu_k
    alpha = params(2:2:end);  % Even indices: alpha_k

    % Initialize stress
    stress = zeros(size(lambda));

    % Compute stress for each term
    for k = 1:length(mu)
        stress = stress + (2 * mu(k) / alpha(k)) .* ...
                 (lambda.^alpha(k) - (1 ./ sqrt(lambda)).^alpha(k));
    end
    
end
