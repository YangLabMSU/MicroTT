function ComparativeParameterPlotting_Speed(ComparisonData)

Variables = double(ComparisonData{1,6}) ; 
[Variables, sort_index] = sort(Variables);

SEMArea = ComparisonData{1,7} ; 
SEMArea = SEMArea(sort_index,1) ;

for n = 1:size(sort_index,1) 

    LegendString(n,1) = sprintf("Write Speed: %s, SEM Area: %s", string(Variables(n,1)), string(SEMArea(n,1))) ; 

end

sgtitle(ComparisonData{1,5}, 'fontsize', 16) ;

E1 = ComparisonData{1,1}(:,1) ; 
E2 = ComparisonData{1,1}(:,2) ; 
E3 = ComparisonData{1,1}(:,3) ; 

Modulus = [ E1  E2  E3 ] ; 

ErrorE1 = ComparisonData{1,2}(:,1) ; 
ErrorE2 = ComparisonData{1,2}(:,2) ; 
ErrorE3 = ComparisonData{1,2}(:,3) ;

ModulusErrors = [ ErrorE1  ErrorE2  ErrorE3 ] ; 

Modulus = Modulus(sort_index, :) ;
ModulusErrors = ModulusErrors(sort_index, :) ;

ModLabels = { "E_1" , "E_2", "E_3" } ;

x = 1:length(ModLabels) ; 

subplot(1,2,1) ; 

% Bar chart with error bars
%b = bar(x, Modulus, 'FaceColor', 'flat');
b = bar(Modulus', 'FaceColor', 'flat', 'LineWidth', 1);
hold on; 

% Get the number of groups and bars
[nbars, ngroups] = size(Modulus);

% Calculate the x coordinates for the error bars
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Loop through each bar group
for i = 1:nbars
    % Calculate the center of each bar
    x_error = x - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_error, Modulus(i,:), ModulusErrors(i,:), 'k', 'linestyle', 'none', 'linewidth', 1);
end

% Customize the plot
set(gca, 'XTick', x, 'XTickLabel', ModLabels, 'FontSize', 14) ;
xlabel('Fitting Moduli') ;
ylabel('Moduli Values (MPa)') ;
ylim([0 2000]) ;
yticks(linspace(0, 2000, 5));
grid on ; 

hold off;


Lam1 = ComparisonData{1,3}(:,1) ; 
Lam2 = ComparisonData{1,3}(:,2) ;  

Lamda = [ Lam1  Lam2 ] ; 

ErrorLam1 = ComparisonData{1,4}(:,1) ; 
ErrorLam2 = ComparisonData{1,4}(:,2) ; 

LamErrors = [ ErrorLam1  ErrorLam2 ] ; 

Lamda = Lamda(sort_index, :) ;
LamErrors = LamErrors(sort_index, :) ;

LamLabels = { "Lamda_1", "Lamda_2" } ;

x2 = 1:length(LamLabels) ; 

subplot(1,2,2) ; 

% Bar chart with error bars
b2 = bar(Lamda', 'FaceColor', 'flat', 'LineWidth', 1);
hold on; 

% Get the number of groups and bars
[nbars2, ngroups2] = size(Lamda);

% Calculate the x coordinates for the error bars
groupwidth2 = min(0.8, nbars2/(nbars2 + 1.5));

% Loop through each bar group
for i = 1:nbars2
    % Calculate the center of each bar
    x_error2 = x2 - groupwidth2/2 + (2*i-1) * groupwidth2 / (2*nbars);
    errorbar(x_error2, Lamda(i,:), LamErrors(i,:), 'k', 'linestyle', 'none', 'linewidth', 1);
end

% Customize the plot
set(gca, 'XTick', x, 'XTickLabel', LamLabels, 'FontSize', 14);
xlabel('Fitting Strain Coefficients');
ylabel('Strain Coefficients');
leg = legend(LegendString, 'Location', 'northwest', 'FontSize', 12, 'box', 'off') ;
title(leg, 'Speed (mm/s), Area (um^2)') ;
ylim([0 1.75]) ;
yticks(linspace(0, 1.75, 5));
grid on ; 

hold off;


end
