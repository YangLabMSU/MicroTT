clear ; clc ; close ;

% Load Yield Point and Yield Strain Into Stretch Exp Data Table
load('Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat') ; 

for n = 1:size(StretchExperimentData)

    % Load In Critical Data

    if string(StretchExperimentData{n,4}) ~= "Atypical Curve"

        Stress = StretchExperimentData{n,2} ;
        Strain = StretchExperimentData{n,3} ;
        CriticalPts = StretchExperimentData{n,4} ;
        YieldIdx = CriticalPts(1) ;
        YieldStress = Stress(YieldIdx) ;
        YieldStrain = Strain(YieldIdx) ;
        StretchExperimentData{n, 7} = [ YieldStrain, YieldStress ] ;

    end

end

save('Stretch Experiment Data Fit - Sub 6-5-24 - v2.mat', "StretchExperimentData") ;
