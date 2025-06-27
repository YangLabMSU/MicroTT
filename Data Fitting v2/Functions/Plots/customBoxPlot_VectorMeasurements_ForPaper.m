function customBoxPlot_VectorMeasurements_ForPaper(powerData)

% Extract unique power levels
uniquePowers = unique(powerData(:, 1));

% Initialize cell array for measurements corresponding to each power level
dataCell = cell(1, length(uniquePowers));

% Organize measurements by power level
for i = 1:length(uniquePowers)
    dataCell{i} = powerData(powerData(:, 1) == uniquePowers(i), 2);
end

% Call the existing custom box plot function with the organized data
%customBoxPlot_withStats_v9(dataCell);
customBoxPlot_noStats_ForPaper_v8(dataCell) ; 

% Customize x-axis tick labels to show power levels
xticklabels(uniquePowers);
xlabel('Power Level');
ylabel('Measurement');

end
