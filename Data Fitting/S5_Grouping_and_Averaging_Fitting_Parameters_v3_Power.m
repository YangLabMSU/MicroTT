clear ; clc ; close all ;

% Generating IP-S Power Table without a care for Strain Rate
clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16] ;

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

    ConstantParams = Data(matchingRows,PowCompColIdx) ;
    Variables = (double(Data(matchingRows, CompColumn)).*50)/100 ;
    SEMAreas = AveragedStretchExps(matchingRows,1) ;
    CompData = AveragedStretchExps(matchingRows,12) ;
    YieldData = AveragedStretchExps(matchingRows,13) ;
    Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s", ...
        ConstantParams(1,:)) ;

    for nn = 1:size(CompData,1)

        SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
        FitParameters = CompData{nn,1} ;
        Yield = YieldData{nn,1} ;
        Mods = FitParameters(:, [1 2 4]) ;
        Lams = FitParameters(:, [3 5]) ;
        Yields = Yield(:,[1 2]) ;

        ModData1{i,nn} = Mods ;
        LamData1{i,nn} = Lams ;
        YSOut1{i,nn} = Yields ;

    end

    [~, sort_index] = sort(Variables);
    SortIdx{i,1} = sort_index ;

    CompDataTable1{i,1} = Details ;
    CompDataTable1{i,2} = Variables ;
    CompDataTable1{i,3} = SEMArea ;

    ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

    i = i + 1 ;

    clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

end

ToKeep = 11:16 ;
ConstantParamsKeep = ConstantParamsKeep(ToKeep,:) ;

for n = 1:length(ToKeep)
    CompDataTable{n,1} = CompDataTable1{ToKeep(n), 1};
    CompDataTable{n,2} = CompDataTable1{ToKeep(n), 2};
    CompDataTable{n,2} = CompDataTable1{ToKeep(n), 3};

    ModData{n,1} = ModData1{ToKeep(n),:} ;
    LamData{n,1} = LamData1{ToKeep(n),:} ;
    YSOut{n,1} = YSOut1{ToKeep(n),:} ;
end

Combine = [ 1 2 3 ; 4 5 6 ] ; 

for n = 1:size(Combine,1) 

    ModulusData = [] ; 
    LamdaData = [] ; 
    YieldData = [] ; 

    CombineIdx = Combine(n,:) ; 
    for nn = 1:size(CombineIdx,2) 

        Mod  = ModData{CombineIdx(nn)} ; 

        ModulusData = [ ModulusData ; ModData{CombineIdx(nn)}] ;
        LamdaData = [ LamdaData ; LamData{CombineIdx(nn)}] ; 
        YieldData = [ YieldData ; YSOut{CombineIdx(nn)}] ; 

    end

    ModDataOut{n,1} = ModulusData ;
    LamdaDataOut{n,1} = LamdaData ; 
    YieldDataOut{n,1} = YieldData ; 

end

ConstantParamsKeep = ConstantParamsKeep([1,4],1:end-1) ;



