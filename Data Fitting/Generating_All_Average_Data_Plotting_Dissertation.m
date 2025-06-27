clear ; clc ; close all ;

% Averaging all Large Strain IP-S Experiments for Group Evaluations of
% General Behaviors

% Generating IP-S Large Strain Testing Table
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Breaking down and fitting the stress strain curve
load('Stretch Experiment Data Fit.mat') ;

% Find all IP-S Experiments
targetString = 'IP-Visio';

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
%%

fig1 = figure('units', 'inches', 'Position', [  16, 2.5, 4, 5 ]); hold on;
 
data = AllFitValues(:,7) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels({'Yield Stress'});
ylabel('Stress (MPa)', 'FontSize', 14);
title('Yield Stress', 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 


fig2 = figure('units', 'inches', 'Position', [ 11, 2.5, 12, 5 ]); hold on;

subplot(1,3,1) ; 
data = AllFitValues(:,1) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels({'E_1'});
ylabel('Moduli (MPa)', 'FontSize', 14);
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

subplot(1,3,2) ; 
data = AllFitValues(:,2) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels({'E_2'});
% ylabel('Moduli (MPa)', 'FontSize', 14);
% title('Moduli');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

subplot(1,3,3) ; 
data = AllFitValues(:,4) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
xticklabels({'E_3'});
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

sgtitle("Moduli Values",'FontSize', 15, 'FontWeight', 'bold');


fig3 = figure('units', 'inches', 'Position', [ 16, 2.5, 8, 5 ]); hold on;

subplot(1, 2, 1) ; 
data = AllFitValues(:,3) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
xticklabels({'\lambda _1'});
ylabel('Strain Coefficient', 'FontSize', 14);
%title('Strain Coefficient');
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

subplot(1, 2, 2) ; 
data = AllFitValues(:,5) ;
customBoxPlot(data) ;
xlim([0.5 1.5]) ;
yLimits = ylim ;
yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
xticklabels({'\lambda _2'});
set(gca, 'FontSize', 14) ;
ax = gca;
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ; 

sgtitle("Strain Coefficients", 'FontSize', 15, 'FontWeight', 'bold') ; 


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
% 
% IPVisioFitValues = AllFitValues ;
% save("IP-Visio Fit Values for Comparison", "IPVisioFitValues") ;



