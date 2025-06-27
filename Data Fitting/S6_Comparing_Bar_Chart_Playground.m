clear ; clc ; close ;


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
errorbar(x, means, errors, 'k', 'LineStyle', 'none');

% % Overlay data points
% for i = 1:length(parameters)
%     x = repmat(i, length(data{i}), 1); % X locations for each data point
%     scatter(x, data{i}, 'r', 'filled', 'jitter', 'on', 'jitterAmount', 0.1);
% end