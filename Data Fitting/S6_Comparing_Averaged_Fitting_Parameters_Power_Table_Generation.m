clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
PowCompColIdx = [1, 3:size(Data,2)] ;
CompColumn = 2 ; 
[PowerComps, ~, PCidx] = unique(Data(:,PowCompColIdx), 'rows');
i = 1 ;
for n = 1:size(PowerComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (PCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,PowCompColIdx) ;
        Variables = (double(Data(matchingRows, CompColumn)).*50)/100 ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;         
        CompData = AveragedStretchExps(matchingRows,12) ;
        YieldData = AveragedStretchExps(matchingRows,13) ;
        Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
            FitParameters = CompData{nn,1} ;
            Yield = YieldData{nn,1} ;
            Mods = FitParameters(:, [1 2 4]) ;
            Lams = FitParameters(:, [3 5]) ;
            Yields = Yield(:,[1 2]) ;

            ModData{i,nn} = Mods ;
            LamData{i,nn} = Lams ;
            YSOut{i,nn} = Yields ;

        end

        [~, sort_index] = sort(Variables);
        SortIdx{i,1} = sort_index ; 

        CompDataTable{i,1} = Details ;
        CompDataTable{i,2} = Variables ;
        CompDataTable{i,3} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

    end
end

% Combine the first 3 rows
for n = 1:5
combinedModData{1,n} = [ ModData{1, n} ; ModData{2, n} ; ModData{3, n} ];
combinedModData{2,n} = [ ModData{4, n} ; ModData{5, n} ; ModData{6, n} ];


combinedLamData{1,n} = [ LamData{1, n} ; LamData{2, n} ; LamData{3, n} ];
combinedLamData{2,n} = [ LamData{4, n} ; LamData{5, n} ; LamData{6, n} ];


combinedYSData{1,n} = [ YSOut{1, n} ; YSOut{2, n} ; YSOut{3, n} ];
combinedYSData{2,n} = [ YSOut{4, n} ; YSOut{5, n} ; YSOut{6, n} ];
end

% combinedModData = { combinedModData1; combinedModData2 };
% combinedLamData = { combinedLamData1 ; combinedLamData2 };
% combinedYSData = { combinedYSData1; combinedYSData2 } ;

NewConstantParamsKeep(1,:) = ConstantParamsKeep(1,1:end-1) ; 
NewConstantParamsKeep(2,:) = ConstantParamsKeep(4,1:end-1) ; 

NewCompDataTable{1,2} = CompDataTable{1,2} ; 
NewCompDataTable{2,2} = CompDataTable{4,2} ; 

NewCompDataTable{1,3} = [ CompDataTable{1,3} ; CompDataTable{2,3} ; CompDataTable{3,3} ] ;  
NewCompDataTable{2,3} = [ CompDataTable{4,3} ; CompDataTable{5,3} ; CompDataTable{6,3} ] ;  

NewCompDataTable{1,1} = "IP-S, Speed: 50 mm/s, w x h: 1 x 2 um, S x H: 0.5 x 0.5 um, Style: Vertical" ; 
NewCompDataTable{2,1} = "IP-S, Speed: 55 mm/s, w x h: 1 x 2 um, S x H: 0.2 x 0.4 um, Style: Cross" ; 

NewSortIndex{1,1} = SortIdx{1,1} ; %[ SortIdx{1,1} SortIdx{2,1} SortIdx{3,1} ] ; 
NewSortIndex{2,1} = SortIdx{4,1} ; %[ SortIdx{4,1} SortIdx{5,1} SortIdx{6,1} ] ; 

clear SortIdx YSOut ModData LamData ConstantParamsKeep CompDataTable ; 

ModData = combinedModData ; 
LamData = combinedLamData ; 
YSOut = combinedYSData ; 
CompDataTable = NewCompDataTable ; 
ConstantParamsKeep = NewConstantParamsKeep ; 
SortIdx = NewSortIndex ; 

for n = 1 

    for nn = 1:1:5
        
        Moduli = ModData{n,nn} ; 
        ModMean = mean(Moduli) ; 
        ModStd = std(Moduli) ; 

        YStress = YSOut{n,nn} ; 
        YStressMean = mean(YStress) ; 
        YStressStd = std(YStress) ; 

        Lambda = LamData{n,nn} ; 
        LambdaMean = mean(Lambda) ; 
        LambdaStd = std(Lambda) ; 

        Mod1 = sprintf("%.0f +- %.0f", ModMean(1), ModStd(1)) ;
        Mod2 = sprintf("%.0f +- %.0f", ModMean(2), ModStd(2)) ;
        Mod3 = sprintf("%.0f +- %.0f", ModMean(3), ModStd(3)) ;
        Lam1 = sprintf("%.3f +- %.3f", LambdaMean(1), LambdaStd(1)) ;
        Lam2 = sprintf("%.3f +- %.3f", LambdaMean(2), LambdaStd(2)) ;
        YS = sprintf("%.0f +- %.0f", YStressMean(2), YStressStd(2)) ;

        Out(nn,:) = [YS Mod1 Mod2 Lam1 Mod3 Lam2 ] ; 

        

    end

end




