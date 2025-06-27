clear ; clc ; close ; 

% Build and Averaged Experiment Table
load('Average Ogden Experiments - v1.mat');

Table = [] ; 

for n = 2:size(AveragedStretchExps,1) 

    ExpDets = AveragedStretchExps{n,1} ;
      
    ArrayNums = ExpDets(:,5) ; 
    ArrayPoss = strjoin(ArrayNums, ", ") ;
    InitialFiberLength = mean(double(ExpDets(:,16))) ; 
    
    TableAdd = [ ExpDets(1,[ 1 2 4 ]) ArrayPoss ExpDets(1,7:15) InitialFiberLength ExpDets(1,17:18)] ; 
    Table = [ Table ; TableAdd ] ; 

end

TableExpHeader = [ "Material", "Substrate", "Test Condition", "Array Positions", "Beam Stiffness (N/m)", ...
    "Writing Power (%max, 50 mW)", "Writing Speed (mm/s)", "Fiber Width (um)", "Fiber Height (um)", "Slice Distance (um)", "Hatch Distance", ...
    "Hatch Style", "SEM Fiber Area (um^2)", "Average Initial Fiber Length (um)","Experiment Displacement (um)", "Experiment Displacement Rate (um/s)" ] ; 

AverageTable = [ TableExpHeader ; Table] ;

save("Average Ogden Experiments - v1 - Table", "AverageTable") ; 