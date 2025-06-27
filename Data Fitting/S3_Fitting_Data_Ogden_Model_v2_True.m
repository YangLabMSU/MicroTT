clear; clc; close all; 
% Ogden Fitting - Main Script - v2

% Load data
load('All_IPS_LargeStrain_Data.mat') ; 
StretchExperimentData = All_IPS_Data(2:end,:) ; 
New_All_IPS_Data = All_IPS_Data(:, [1:4 7]) ; 
New_All_IPS_Data(1,6:7) = All_IPS_Data(1,5:6) ;
%%
for n = 1:size(StretchExperimentData, 1) %[1:50 102:size(StretchExperimentData, 1)]

% Select a specific dataset to fit
Stress = StretchExperimentData{n, 2};
Strain = StretchExperimentData{n, 3};

% Parameters & Critical Points
Parameters = StretchExperimentData{n,1} ; 
CriticalPts = StretchExperimentData{n,4};

% Yield Strain
YieldIdx = CriticalPts(1) ;
YieldStrain = Strain(YieldIdx) ; 
MaxStrain = Strain(end) ; 

if MaxStrain > 0.1

    StrainIdx1 = find(Strain > 0.1, 1, "first") ;
    StrainInterp1 = linspace(Strain(1), Strain(StrainIdx1), 200) ;

    DownStrain = MaxStrain - 0.1 ;
    NumIntPts = round(DownStrain*100) ; 

    StrainInterp2 = linspace(Strain(StrainIdx1), Strain(end), NumIntPts) ;

    StrainInterp = [ StrainInterp1 StrainInterp2 ] ;

else 

    StrainInterp = linspace(Strain(1), Strain(end), 200) ; 

end

% Interpolate Stress
if n == 145 
    Strain = Strain(2:end, 1) ; 
    Stress = Stress(2:end, 1) ; 
end

StressInterp = interp1(Strain, Stress, StrainInterp) ; 

% Update Yield Idx
%CriticalPts(1) = find(StrainInterp > YieldStrain, 1, "first") ; 

% True Stress and Strain 
TrueStress = Stress.*(1+Strain) ; 
TrueStrain = log(1+Strain) ; 
TrueStressInterp = StressInterp.*(1+StrainInterp); 
TrueStrainInterp = log(1+StrainInterp);

% Stetch
Lambda = 1 + Strain ; 
LambdaInterp = 1 + StrainInterp; % Stretch ratio

% Lo and Ao
Lo = double(Parameters(16)) ; 
Ao = double(Parameters(15)) ;

% Reconversion
Force = Stress.*Ao ; 
Length = (Strain*Lo) + Lo ; 

% Instantaneous Area
A = (Ao.*Lo) ./ Length ; 
TrueStressCheck = Force ./ A ; 

% Initial guesses [mu1, alpha1, mu2, alpha2, ...]
InitialGuess = [701.3955  -21.1822  -337.9074   10.6811];

% Perform fitting
[FittingValues, ~] = OgdenLargeStrainFitting_v2(InitialGuess, TrueStressInterp, LambdaInterp);

% Recompute Residuals
residuals = computeResiduals(FittingValues, Lambda, TrueStress) ; 

% Goodness of Fit Metrics
SS_res = sum(residuals.^2); % Sum of squared residuals
SS_tot = sum((TrueStress - mean(TrueStress)).^2); % Total sum of squares
R_squared = 1 - (SS_res / SS_tot); % Coefficient of determination
RMSE = sqrt(mean(residuals.^2)); % Root Mean Squared Error
GoodnessOfFit = [R_squared, RMSE];

% Display results
disp("Fitted Parameters:");
disp(FittingValues);
disp("Goodness of Fit:");
disp(GoodnessOfFit);

PlottingSummaryFunction_Ogden_Engineering(TrueStress, TrueStrain, Lambda, Parameters, CriticalPts, FittingValues, GoodnessOfFit)

New_All_IPS_Data{n+1, 6} = FittingValues ; 
New_All_IPS_Data{n+1, 7} = GoodnessOfFit ;

end

All_IPS_Data_Ogden = New_All_IPS_Data ; 
save("All_IPS_LargeStrain_Data_TrueOgden_v3.mat", "All_IPS_Data_Ogden", "All_IPS_Data_Table") ; 

