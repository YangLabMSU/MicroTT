clear ; clc ; close ;

% Averaging Like-Experiments
load('All_IPS_LargeStrain_Data_TrueOgden_v6.mat') ;
AllExperimentTable = All_IPS_Data_Table ; 
AllExperimentData = All_IPS_Data_Ogden(2:end,:) ; 

data = [] ;

for n = 2:size(AllExperimentTable,1)

    path = AllExperimentTable(n,27) ;
    load(path) ;

    if isfield(ProcessedData, 'StretchIdx')

        data = [ data ; AllExperimentTable(n,:) ] ;

    end

end

parametercolumns = [1 8 9 10 11 12 13 14 18] ;
dataPathColumn = 27 ;
[uniqueParams, ~, idx] = unique(data(:, parametercolumns), 'rows');

for i = 1:size(uniqueParams, 1)

    Stress = [] ; 
    Strain = [] ; 
    Yield = [] ; 
    Fit = [] ; 
    GoF = [] ; 

    % Find the indices of rows matching the current parameter combination
    matchingRows = (idx == i) ;
    RawStress = AllExperimentData(matchingRows, 2) ;
    RawStrain = AllExperimentData(matchingRows, 3) ;
    YieldData = AllExperimentData(matchingRows, 5) ; 
    FitParams = AllExperimentData(matchingRows, 6) ; 
    GoFData = AllExperimentData(matchingRows, 7) ; 

    for j = 1:length(RawStress)

        % Stress & Strain
        Stress(:,j) = RawStress{j} ; 
        Strain(:,j) = RawStrain{j} ;
        Yield(j,:) = YieldData{j} ; 
        Fit(j,:) = FitParams{j} ; 
        GoF(j,:) = GoFData{j} ; 

    end

    % Calculate the average data
    AvgStress = mean(Stress,2) ;
    StdStress = std(Stress,1,2); 
    AvgStrain = mean(Strain,2) ;
    StdStrain = std(Strain,1,2); 

    % Store the averaged data
    AveragedStretchExps{i, 1} = data(matchingRows, :);
    AveragedStretchExps{i, 2} = Stress ; 
    AveragedStretchExps{i, 3} = Strain ; 
    AveragedStretchExps{i, 4} = [ AvgStress StdStress ] ; 
    AveragedStretchExps{i, 5} = [ AvgStrain StdStrain ] ; 
    AveragedStretchExps{i, 6} = Yield ; 
    AveragedStretchExps{i, 7} = Fit ; 
    AveragedStretchExps{i, 8} = GoF ; 

end

Header = {"Details", "Stress Data", "Strain Data", "Average Stess & Std", "Average Strain & Std", "Yield Strain & Stress", "Ogden Parameters", "Goodness of Fit Stats"}; 
AveragedStretchExps = [Header ; AveragedStretchExps] ; 
save("Average Ogden Experiments - v1", "AveragedStretchExps") ;
