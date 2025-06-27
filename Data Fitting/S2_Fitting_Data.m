clear ; clc ; close ; 

% Breaking down and fitting the stress strain curve
%load('All IPS Fatigue Stretch Experiments Table.mat') ;
load('All IPS Hatch - Sub 6-5-24 - Table.mat') ;  
Details = AllStretchExperimentTable(2:end,:) ; 
load('All IPS Hatch - Sub 6-5-24 - Data.mat') ; 
%load('All IPS Fatigue Stretch Experiments Data.mat') ; 

for n = 1:size(StretchExperimentData)

    Stress = StretchExperimentData{n,2} ; 
    Strain = StretchExperimentData{n,3} ;
    
    % Linear Index
    LinIdx = 1:round(0.5*YieldIdx) ;
    LinStrain = Strain(LinIdx) ; 
    LinStress = Stress(LinIdx) ; 

    % Fit Youngs Modulus to Data Prior to Yield Point
    % Fit a linear model to the data
    LFT = fittype({'x'}) ; % fit type
    LinearModel = fit(LinStrain, LinStress, LFT);
    E1 = LinearModel.a ; % Youngs Modulus
    LSP = Strain(1:YieldIdx) ; 
    LinMod = E1*LSP ; 

    % Plotting
    plot(Strain, Stress, '-b', 'LineWidth', 3) ; hold on; 
    plot(LSP, LinMod, '--r', 'linewidth', 2) ; 
    plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

    % Find Peak of the dStrain
    [pks2, locs2] = findpeaks(-NormdStrain) ; 
    % plot(locs2,pks2,'+', 'Color','r', 'MarkerSize',10) ; 

    % Equilibrium Point
    EquilIdx = locs2(1) ; 
    EqStress = Stress(EquilIdx) ; 
    EqStrain = Strain(EquilIdx) ; 
    plot(EqStrain, EqStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

    if Strain(end) > 0.5
        % Find 50% Strain Point
        FPSPIdx = find(Strain >= 0.5, 1, 'first') ; 
        FPStress = Stress(FPSPIdx) ; 
        FPStrain = Strain(FPSPIdx) ; 
        plot(FPStrain, FPStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;
    else
        FPStress = Stress(end) ; 
        FPStrain = Strain(end) ; 
        plot(FPStrain, FPStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;
    end

    % Put Fitting Constants into a vector
    FittingConstants = [ E1, YieldStrain, YieldStress, EqStrain, EqStress, FPStrain, FPStress ] ;
    InitialFitVals = [ 475 0.2 1700 1.05 ] ;
    FittingValues = TPPTT_LargeStrainFittingFunc(InitialFitVals, FittingConstants, Stress, Strain) ;

    hold off ; 

    pause(1) ; 


end