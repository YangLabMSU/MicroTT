clear ; clc ; close ;

% Generating IP-S Large Strain Testing Table
load('Average Stretch Experiment Fits - v2') % - Sub 6-14.mat')
load('Average Stretch Table') ; % - Sub 6-14.mat') ;

% Find all IP-S Experiments
targetString = 'IP-Dip';

% Use strcmp to create a logical array of matches
AvgTab = AverageTable(2:end,:) ;
DetHead = AverageTable(1, 6:16) ;
matches = strcmp(AvgTab(:,1), targetString);

% Use find to get the indexes of the matches
IPS_Exps_Idx = find(matches);
i = 1 ; 
for n = 1:size(IPS_Exps_Idx,1)

    Idx = IPS_Exps_Idx(n) ;
    Details = AvgTab(Idx, 6:16) ;
    Details(1) = (double(Details(1))*50)/100 ;
    Details(8) = round(double(Details(8)),1) ;
    Details(9) = round(double(Details(9)),1) ;
    FitValues = AveragedStretchExps{Idx, 12} ;
    YieldValues = AveragedStretchExps{Idx, 13} ;

    if size(FitValues,1) > 1
        AvgFitVals = mean(FitValues) ;
        stdFitVals = std(FitValues) ;

        AvgYieldVals = mean(YieldValues) ; 
        stdYieldVals = std(YieldValues) ; 

        FitVals(1,1) = round(AvgFitVals(1)) + "+-" + round(stdFitVals(1)) ;
        FitVals(1,2) = round(AvgFitVals(2)) + "+-" + round(stdFitVals(2)) ;
        FitVals(1,3) = round(AvgFitVals(3),3) + "+-" + round(stdFitVals(3),3) ;
        FitVals(1,4) = round(AvgFitVals(4)) + "+-" + round(stdFitVals(4)) ;
        FitVals(1,5) = round(AvgFitVals(5),3) + "+-" + round(stdFitVals(5),3) ;

        YieldVals(1,1) = round(AvgYieldVals(1),3) + "+-" + round(stdYieldVals(1),3) ; 
        YieldVals(1,2) = round(AvgYieldVals(2)) + "+-" + round(stdYieldVals(2)) ;

        TableVector(i,:) = [ Details YieldVals FitVals ] ;
        i = i + 1 ;
    end
end


% Define the order of columns for sorting
sortOrder = [1, 2, 5, 6, 11];

% Sort the matrix using the specified columns in the given order
sortedMatrix = sortrows(TableVector, sortOrder);

Geometry = sortedMatrix(:,3) + " x " + sortedMatrix(:,4) ; 
SliceHat = sortedMatrix(:,5) + " x " + sortedMatrix(:,6) ;

MatOut = [ sortedMatrix(:, 1:2) Geometry SliceHat sortedMatrix(:,7:end) ] ;  
Header = [ "Writing Power (mW)" DetHead(:, 2) "Design Width x Height (um)" "Slice x Hatch (um)" DetHead(:,7:end) "Yield Strain" "Yield Stress (MPa)" "First Modulus" "Second Modulus" "First Strain Coefficient" "Third Modulus" "Second Strain Coefficient"] ; 
MatOut = [ Header ; MatOut ] ; 

AveragedStretchExpsDataTable = MatOut ; 
save("Averaged Stretch Experiments Data Table - IPDip", "AveragedStretchExpsDataTable") ; 
