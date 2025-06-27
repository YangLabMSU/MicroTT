clear ; clc ; close ;

% Averaging all Large Strain IP-S Experiments for Group Evaluations of
% General Behaviors

% Generating IP-S Large Strain Testing Table
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Breaking down and fitting the stress strain curve
load('Stretch Experiment Data Fit.mat') ;

% Find all IP-S Experiments
targetString = 'IP-S';

% Use strcmp to create a logical array of matches
AvgTab = AverageTable(2:end,:) ;
DetHead = AverageTable(1, 6:16) ;
matches = strcmp(AvgTab(:,1), targetString);

% Use find to get the indexes of the matches
IPS_Exps_Idx = find(matches);
AllFitValues = [] ;
for n = 1:size(IPS_Exps_Idx,1)

    Idx = IPS_Exps_Idx(n) ;
    FitValues = AveragedStretchExps{Idx, 12} ;
    YieldValues = AveragedStretchExps{Idx, 13} ; 
    AllFitValues = [ AllFitValues ; FitValues YieldValues ] ;

end

% Create the plot
figure; hold on;

subplot(1,5,1) ; 
data = AllFitValues(:,7) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
ylim([20 80]) ;
yticks(round(linspace(20,80,6))) ;
xticklabels({'Yield Stress'});
ylabel('Stress (MPa)', 'FontSize', 14);
title('Yield Stress');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

subplot(1,5,[ 2 3 ]) ; 
data = AllFitValues(:,[1 2 4]) ;
customBoxPlot(data) ;
xlim([0.5 3.5]) ;
ylim([0 2200]) ;
yticks(round(linspace(0,2200,6))) ;
xticklabels({'E_1', 'E_2', 'E_3'});
ylabel('Moduli (MPa)', 'FontSize', 14);
title('Moduli');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

subplot(1,5, [ 4 5]) ; 
data = AllFitValues(:,[3 5]) ;
customBoxPlot(data) ;
xlim([0.5 2.5]) ;
ylim([0 1.25]) ;
yticks(round(linspace(0,1.25,6),2)) ;
xticklabels({'Lambda_1', 'Lambda_2'});
ylabel('Strain Coefficient', 'FontSize', 14);
title('Strain Coefficient');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 



% E1Avg = mean(AllFitValues(:,1)) ;
% E1Std = std(AllFitValues(:,1)) ;
%
% E2Avg = mean(AllFitValues(:,2)) ;
% E2Std = std(AllFitValues(:,2)) ;
%
% E3Avg = mean(AllFitValues(~isnan(AllFitValues(:,4)),4)) ;
% E3Std = std(AllFitValues(~isnan(AllFitValues(:,4)),4)) ;
%
% Lam1Avg = mean(AllFitValues(:,3)) ;
% Lam1Std = std(AllFitValues(:,3)) ;
%
% Lam2Avg = mean(AllFitValues(~isnan(AllFitValues(:,5)),5)) ;
% Lam2Std = std(AllFitValues(~isnan(AllFitValues(:,5)),5)) ;
%
% % Plotting from GPT
%
% % Sample Data
% data = AllFitValues(:,1) ; % Replace this with your actual data
% average = mean(data);
% std_dev = std(data);
%
% % Plot all data points
% figure;
% hold on;
%
% numPoints = length(data);
% x = 0.95 + (1.05 - 0.95) * rand(numPoints, 1);
% plot(x, data, '.', 'MarkerSize', 10); hold on ;
% boxplot(data, 'Positions', 1, 'Widths', 0.3) ;
%
% % Customizing the plot
% set(gca, 'XTick', []);
% title('Box and Whisker Plot with Data Points');
% ylabel('Values');
%
% hold off;
%
%
%
%
%
%     % Customize the plot
%     xlim([0.5, NumVectors+0.5]);
%     % ylim([0 2000]);
%     xticks(1);
%     xticklabels({'E_1'});
%     % xlabel('Category');
%     ylabel('Values');
%     title('Custom Box Plot');
%     hold off;
%




