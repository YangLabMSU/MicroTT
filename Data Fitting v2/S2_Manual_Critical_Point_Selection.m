% clear ; clc ; close ;
%
% % Need to Determine the Critical Points for All Stretch Experiments (if applicable)
% load('All Stretch Experiments Table.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ;
% load('All Stretch Experiment Data.mat') ;

%%
%load('Stretch Experiment Data Fit.mat') ;
%
% load('All Stretch Experiments Table - Sub 6-14.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ;
% load('All Stretch Experiment Data - Sub 6-14.mat') ;

% load('All IPS Fatigue Stretch Experiments Table.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ;
% load('All IPS Fatigue Stretch Experiments Data.mat') ;

load('All IP-PDMS - Table.mat') ;
Details = AllStretchExperimentTable(2:end,:) ;
load('All IP-PDMS - Data.mat');
PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.3, 0.10, 0.5, 0.8 ] ;

for n = 1:size(StretchExperimentData,1)

    Stress = StretchExperimentData{n,2} ;
    Strain = StretchExperimentData{n,3} ;


    CriticalPoints = ManualDeterminedCriticalPoints_v2(Stress,Strain) ;

    check2= questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
        "Yes", "No", "Yes") ;

    switch check2
        case "Yes"

            StretchExperimentData{n,4} = CriticalPoints ;

        case "No"

            CriticalPoints = "Adjust Fit Style" ;
            StretchExperimentData{n,4} = CriticalPoints ;

    end


    hold off ;

end

save("Stretch Experiment Data Fit - IP-PDMS - v2.mat", "StretchExperimentData") ;
