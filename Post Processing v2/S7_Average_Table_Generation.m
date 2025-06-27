clear ; clc ; close ; 

% Build and Averaged Experiment Table
load("Average Stretch Experiments - IP-PDMS.mat") ; 

Table = [] ; 

for n = 1:size(AveragedStretchExps,1) 

    % if AveragedStretchExps{n,5} == "Needs Adjusted"
    % 
    %     ExpDets = AveragedStretchExps{n,7} ;
    %     Stress = AveragedStretchExps{n, 10} ; 
    %     Strain = AveragedStretchExps{n, 11} ;
    % 
    % else
        
    ExpDets = AveragedStretchExps{n,1} ; 
    Stress = AveragedStretchExps{n, 4} ; 
    Strain = AveragedStretchExps{n, 5} ;

    ArrayNums = ExpDets(:,5) ; 
    ArrayPoss = strjoin(ArrayNums, ", ") ;
    InitialFiberLength = mean(double(ExpDets(:,16))) ; 
    
    TableAdd = [ ExpDets(1,[ 1 2 4 ]) ArrayPoss ExpDets(1,7:15) InitialFiberLength ExpDets(1,17:18)] ; 
    Table = [ Table ; TableAdd ] ; 
    AverageData{n,1} = TableAdd ; 
    AverageData{n,2} = Stress ;
    AverageData{n,3} = Strain ;
end

TableExpHeader = [ "Material", "Substrate", "Test Condition", "Array Positions", "Beam Stiffness (N/m)", ...
    "Writing Power (%max, 50 mW)", "Writing Speed (mm/s)", "Fiber Width (um)", "Fiber Height (um)", "Slice Distance (um)", "Hatch Distance", ...
    "Hatch Style", "SEM Fiber Area (um^2)", "Average Initial Fiber Length (um)","Experiment Displacement (um)", "Experiment Displacement Rate (um/s)" ] ; 

AverageTable = [ TableExpHeader ; Table] ;

% save("Average Stretch IP-S - Sub 6-5-24 - Table", "AverageTable") ; 
% save("Average Stretch IP-S - Sub 6-5-24 - Data", "AverageData") ;

save("Average Stretch IP-PDMS - Table", "AverageTable");
save("Average Stretch IP-PDMS - Data", "AverageData")