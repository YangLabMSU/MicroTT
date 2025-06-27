clear ; clc ; close ; 

% % Sample data
% parameters = {'Param1', 'Param2', 'Param3'};
% data = {randn(10, 1) + 5, randn(10, 1) + 7, randn(10, 1) + 6}; % Example data
% means = cellfun(@mean, data);
% errors = cellfun(@std, data); % Using standard deviation as error for this example
% 
% % Create a figure
% figure;
% hold on;
% 
% % Bar chart with error bars
% b = bar(1:length(parameters), means, 'FaceColor', 'flat');
% errorbar(1:length(parameters), means, errors, 'k', 'LineStyle', 'none');
% 
% % Overlay data points
% for i = 1:length(parameters)
%     x = repmat(i, length(data{i}), 1); % X locations for each data point
%     scatter(x, data{i}, 'r', 'filled', 'jitter', 'on', 'jitterAmount', 0.1);
% end
% 
% % % Customize the plot
% % set(gca, 'XTickLabel', parameters);
% % xlabel('Parameters');
% % ylabel('Values');
% % title('Bar Chart with Error Bars and Data Points Overlay');
% % legend({'Mean', 'Data Points'});
% 
% hold off;


% Playing Around with Bar Charts

E1 = [ 700 500 400 ] ; 
E2 = [ 200 300 100 ] ;
E3 = [ 500 600 550 ] ; 

means = [ E1 ; E2 ; E3 ] ; 

Labels = { "E1" , "E2", "E3" } ;

ErrorE1 = [ 100 75 50 ] ; 
ErrorE2 = [ 40 55 30 ] ; 
ErrorE3 = [ 100 120 80 ] ; 

errors = [ ErrorE1 ; ErrorE2 ; ErrorE3 ] ; 

x = 1:length(Labels) ; 

% Create a figure
figure;
hold on;

% Bar chart with error bars
b = bar(x, means, 'FaceColor', 'flat');

% Get the number of groups and bars
[ngroups, nbars] = size(means);

% Calculate the x coordinates for the error bars
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Loop through each bar group
for i = 1:nbars
    % Calculate the center of each bar
    x_error = x - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    disp(x_error) ;
    errorbar(x_error, means(:,i), errors(:,i), 'k', 'linestyle', 'none');
end

% % Overlay data points
% for i = 1:length(Labels)
%     for j = 1:nbars
%         x_data = repmat(x(i) - groupwidth/2 + (2*j-1) * groupwidth / (2*nbars), size(means, 1), 1); % X locations for each data point
%         scatter(x_data, means(:, j), 'r', 'filled', 'jitter', 'on', 'jitterAmount', 0.1);
%     end
% end

% Customize the plot
set(gca, 'XTick', x, 'XTickLabel', Labels);
xlabel('Parameters');
ylabel('Values');
title('Bar Chart with Error Bars and Data Points Overlay');
legend({'Sample 1', 'Sample 2', 'Sample 3'}, 'Location', 'North');

hold off;