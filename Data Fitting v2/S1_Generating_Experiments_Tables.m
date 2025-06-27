clear ; clc ; close ; 

% Check the Averaged Stretch Expreriments Tables to Determine the "Good" Stretch Experiments. 
%load('Average Stretch Experiments.mat') ; 
%load('Average Stretch Experiments - Sub 6-14.mat') ; 
% load("Average Stretch IP-S Fatigue Experiment.mat") ; 
load('Average Stretch Experiments - IP-PDMS.mat') ; 

AllStretchExperimentTable = [] ; 
StretchExperimentData = {} ;

for n = 1:size(AveragedStretchExps, 1)

    % if AveragedStretchExps{n,6} == "Needs Adjusted"
    % 
    %     Exps = AveragedStretchExps{n,7} ; 
    %     StretchStress = AveragedStretchExps{n,8} ; 
    %     StretchStrain = AveragedStretchExps{n,9} ; 
    % 
    % else

        Exps = AveragedStretchExps{n,1} ;
        StretchStress = AveragedStretchExps{n,2} ; 
        StretchStrain = AveragedStretchExps{n,3} ;

    AllStretchExperimentTable = [ AllStretchExperimentTable ; Exps ] ; 

    SEDSize = size(StretchExperimentData,1) ; 
    for nn = 1:size(Exps,1)

        StretchExperimentData{nn+SEDSize,1} = Exps(nn,:) ;
        StretchExperimentData{nn+SEDSize,2} = StretchStress(:,nn) ; 
        StretchExperimentData{nn+SEDSize,3} = StretchStrain(:,nn) ; 

    end

end

Header = ["Material" "Substrate" "Test Date"	"Test Condition"...
    "Array Position" "Beam Thickness (um)" "Beam Stiffness (N/m)" ...
    "Writing Power (%max, 50 mW)" "Writing Speed (mm/s)" "Fiber Width (um)"...
    "Fiber Height (um)" "Slice Distance (um)" "Hatch Distance" "Hatch Style"...
    "SEM Fiber Area (um^2)" "Initial Measured Fiber Length (um)" ...
    "Experiment Displacement (um)" "Experiment Displacement Rate (um/s)"...
    "Hold Duration (s)" "Experiment Cylces" "Recovery Observation time (s)"...
    "Experiment Notes" "Total Frames" "Processed Frames" "Data Smoothing Factor"...
    "Pixel to Micron Adjustment" "Data Path"] ; 

AllStretchExperimentTable = [ Header ; AllStretchExperimentTable ] ; 

% save("All Stretch Experiments Table", "AllStretchExperimentTable") ;
% save("All Stretch Experiment Data", "StretchExperimentData") ; 

% save("All IPS Fatigue Stretch Experiments Table", "AllStretchExperimentTable") ;
% save("All IPS Fatigue Stretch Experiments Data", "StretchExperimentData") ; 

%save("All IPS Hatch - Sub 6-5-24 - Table", "AllStretchExperimentTable") ;
%save("All IPS Hatch - Sub 6-5-24 - Data", "StretchExperimentData") ;

save("All IP-PDMS - Table", "AllStretchExperimentTable");
save("All IP-PDMS - Data", "StretchExperimentData");
