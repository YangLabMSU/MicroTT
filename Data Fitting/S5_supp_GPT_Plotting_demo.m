clear ; clc ; close ; 

% Chat GPT Plotting

% Example data
% Each row is an experiment, each column is a parameter
data = [
    1.1, 2.2, 3.1, 4.1, 5.1;
    1.2, 2.1, 3.2, 4.0, 5.2;
    1.3, 2.0, 3.3, 4.2, 5.3
];

% Create box plot
boxplot(data, 'Labels', {'Param1', 'Param2', 'Param3', 'Param4', 'Param5'}); hold on ; 
title('Box Plot of Fitting Parameters');
xlabel('Fitting Parameters');
ylabel('Values');

% Calculate mean and standard deviation
means = mean(data);
stddevs = std(data);

% Create scatter plot with error bars
errorbar(1:5, means, stddevs, 'o');
set(gca, 'XTick', 1:5, 'XTickLabel', {'Param1', 'Param2', 'Param3', 'Param4', 'Param5'});
title('Mean and Standard Deviation of Fitting Parameters');
xlabel('Fitting Parameters');
ylabel('Values');

% Overlay individual data points
numParams = size(data, 2);
for i = 1:numParams
    % Randomly jitter the x-position of the data points for better visibility
    jitteredX = i + (rand(size(data, 1), 1) - 0.5) * 0.1;
    scatter(jitteredX, data(:, i), 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
end