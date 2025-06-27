function sigma = grayson_polymer_model(params, epsilon)

    E1 = params(1);
    E2 = params(2);
    E3 = params(3);
    Lam1 = params(4);
    Lam2 = params(5);

    sigma = E1 * epsilon - E2 * exp(-Lam1 ./ epsilon) - E3 * exp(-Lam2 ./ epsilon);
    
end