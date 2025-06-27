clear ; clc ; close ;

% Averaging Like-Experiments
load('All Experiments Table.mat') ;

data = [] ;

for n = 2:size(AllExperimentTable,1)

    path = AllExperimentTable(n,27) ;
    load(path) ;

    if isfield(ProcessedData, 'StretchIdx')

        data = [ data ; AllExperimentTable(n,:) ] ;

    end

end

parametercolumns = [1 8 9 10 11 12 13 14 18 ] ;
dataPathColumn = 27 ;
[uniqueParams, ~, idx] = unique(data(:, parametercolumns), 'rows');

for i = 1:size(uniqueParams, 1)

    StressData = [] ; 
    StrainData = [] ; 
    NumPts = [] ; 

    % Find the indices of rows matching the current parameter combination
    matchingRows = (idx == i) ;

    % Load the data for each matching row
    matchingFiles = data(matchingRows, dataPathColumn);

    % Initialize a variable to store the summed data
    sumData = [];

    % Initialize a counter for the number of files
    numFiles = 0;

    for j = 1:length(matchingFiles)

        % Load the data from the file
        load(matchingFiles{j});

        % Ensure all data vectors have the same length
        StretchIdx = round(ProcessedData.StretchIdx(1):1:ProcessedData.StretchIdx(2))' ;
        NumPts(j) = size(StretchIdx,1) ;

    end

    NumPts = round(mean(NumPts)) ;

    for j = 1:length(matchingFiles)

        % Load the data from the file
        load(matchingFiles{j});

        % Ensure all data vectors have the same length
        StretchIdx = round(ProcessedData.StretchIdx(1):1:ProcessedData.StretchIdx(2))' ;
        IdxSize = size(StretchIdx,1) ;
        StretchIdxVal = [ StretchIdx(1) StretchIdx(end) ] ;
        %disp(StretchIdxVal) ;
        StretchIdxVal = IdxSizeCheck(IdxSize, NumPts, StretchIdxVal) ;
        %disp(StretchIdxVal) ;

        % Set New Stretch Idx
        StretchIdx = (StretchIdxVal(1):1:StretchIdxVal(2))' ;

        % Data Matrix
        StressData(:,j) = ProcessedData.Stress(StretchIdx)-ProcessedData.Stress(StretchIdx(1)); 
        StrainData(:,j) = ProcessedData.PlateStrain(StretchIdx)-ProcessedData.PlateStrain(StretchIdx(1)) ; 

    end

    % Calculate the average data
    AvgStress = mean(StressData,2) ;
    StdStress = std(StressData,1,2); 
    AvgStrain = mean(StrainData,2) ;
    StdStrain = std(StrainData,1,2); 

    % Store the averaged data
    averagedResults{i, 1} = data(matchingRows, :);
    averagedResults{i, 2} = StressData ; 
    averagedResults{i, 3} = StrainData ; 
    averagedResults{i, 4} =  [ AvgStress StdStress ] ; 
    averagedResults{i, 5} = [ AvgStrain StdStrain ] ; 

end
