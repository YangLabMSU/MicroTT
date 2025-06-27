function sigma = sls_model(params, epsilon)
    E1 = params(1);
    E2 = params(2);
    tau1 = params(3);
    tau2 = params(4);

    sigma = E1 * epsilon + (E1 - E2) * tau2 * gradient(epsilon) ./ gradient(1:length(epsilon));
    sigma = sigma + tau1 * gradient(sigma) ./ gradient(1:length(sigma));
end
