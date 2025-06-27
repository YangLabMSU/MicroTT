clear; clc; close all; 
% Ogden Fitting - Main Script - v2

% Load data
load('All_IPS_LargeStrain_Data.mat') ; 
StretchExperimentData = All_IPS_Data(2:end,:) ; 
New_All_IPS_Data = All_IPS_Data(:, [1:4 7]) ; 
New_All_IPS_Data(1,6:7) = All_IPS_Data(1,5:6) ;

for n = 1:size(StretchExperimentData, 1) 

% Select a specific dataset to fit
Stress = StretchExperimentData{n, 2};
Strain = StretchExperimentData{n, 3};
lambda = 1 + Strain; % Stretch ratio

StrainInterp = linspace(Strain(1), Strain(end), 1500) ; 
StressInterp = interp1(Strain, Stress, StrainInterp) ; 
lambdaInterp = 1 + StrainInterp ; 

% Parameters & Critical Points
Parameters = StretchExperimentData{n,1} ; 
CriticalPts = StretchExperimentData{n,4}; 

% Initial guesses [mu1, alpha1, mu2, alpha2, ...]
InitialGuess = [701.3955  -21.1822  -337.9074   10.6811];

% Perform fitting
[FittingValues, GoodnessOfFit] = OgdenLargeStrainFitting_v2(InitialGuess, StressInterp, lambdaInterp);

% Display results
disp("Fitted Parameters:");
disp(FittingValues);
disp("Goodness of Fit:");
disp(GoodnessOfFit);

PlottingSummaryFunction_Ogden(Stress, Strain, lambda, Parameters, CriticalPts, FittingValues, GoodnessOfFit)

New_All_IPS_Data{n+1, 5} = FittingValues ; 
New_All_IPS_Data{n+1, 6} = GoodnessOfFit ;

end
