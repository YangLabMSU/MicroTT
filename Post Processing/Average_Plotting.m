clear ; clc ; close ; 

% Plotting Average Results
load('Experiment Averages.mat') ;

PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;

for n = 1:size(averagedResults,1)

    % Plot Individual Experiments
    IndStress = averagedResults{n,2} ; 
    IndStrain = averagedResults{n,3} ; 

    plot(IndStrain, IndStress, 'LineWidth', 2) ; alpha(0.5) ;  hold on ; 


    % Average Plotting
    StressStd = averagedResults{n,4}(:,2) ; 
    Stress = averagedResults{n,4}(:,1) ; 

    StrainStd = averagedResults{n,5}(:,2) ; 
    Strain = averagedResults{n,5}(:,1) ;
    
    plot(Strain, Stress+StressStd, '-b','linewidth', 2) ; 
    plot(Strain, Stress-StressStd, '-b','LineWidth', 2) ; 
    
    plot(Strain, Stress, '-c', 'LineWidth', 4) ; 
    
    choice2 = questdlg('Does the plot look good?', ...
        'Plot Evaluation', ...
        'Yes', 'No', 'Yes');

    switch choice2
        case 'Yes'

            averagedResults{n,6} = "Good" ; 

        case 'No'

            averagedResults{n,6} = "Needs Adjusted" ;

    end

    hold off ; 

end