clear ; clc ; close all ; 

load('Stretch Experiment Data Fit - v2.mat') ; 
 i = 1 ; 
for n = 1:size(StretchExperimentData,1)

    if string(StretchExperimentData{n,4}) ~= "Atypical Curve" 
        
        ErrorVals = StretchExperimentData{n,6} ; 
        Rsquared(i,1) = ErrorVals(1) ; 
        RMSE(i,1) = ErrorVals(2) ; 
        i = i + 1 ; 

    end

end

AvgRsquare = mean(double(Rsquared)) ; 
StdRsquare = std(double(Rsquared)) ; 

AvgRMSE = mean(double(RMSE)) ;
StdRMSE = std(double(RMSE)) ; 

MedRsq = median(double(Rsquared)) ; 
MedRMSE = median(double(RMSE)) ; 

FittingPerc = ( size(Rsquared,1) / size(StretchExperimentData,1) ) * 100 ; 

fprintf("Fitting Success: %0.02f (%d out of %d), R-Squared: %0.04f +- %0.04f, RMSE: %0.03f +- %0.03f", FittingPerc, size(Rsquared,1),...
    size(StretchExperimentData,1), AvgRsquare, StdRsquare, AvgRMSE, StdRMSE) ; 
