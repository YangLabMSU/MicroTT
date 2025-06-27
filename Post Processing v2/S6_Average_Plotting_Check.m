clear ; clc ; close ; 

% Plotting Average Results
%load('Average Stretch Experiments.mat')
%load('Average Stretch Experiments - Sub 6-14.mat')
% load("Average Stretch IP-S Fatigue Experiment.mat") ; 
load('Average Stretch Experiments - IP-PDMS.mat') ; 

PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;

for n = 1:size(AveragedStretchExps,1)

    % Plot Individual Experiments
    IndStress = AveragedStretchExps{n,2} ; 
    IndStrain = AveragedStretchExps{n,3} ; 

    plot(IndStrain, IndStress, 'LineWidth', 2) ; alpha(0.5) ;  hold on ; 

    % Average Plotting
    StressStd = AveragedStretchExps{n,4}(:,2) ; 
    Stress = AveragedStretchExps{n,4}(:,1) ; 

    StrainStd = AveragedStretchExps{n,5}(:,2) ; 
    Strain = AveragedStretchExps{n,5}(:,1) ;
    
    plot(Strain, Stress+StressStd, '-b','linewidth', 2) ; 
    plot(Strain, Stress-StressStd, '-b','LineWidth', 2) ; 
    
    plot(Strain, Stress, '-c', 'LineWidth', 4) ; 
    
    choice2 = questdlg('Does the plot look good?', ...
        'Plot Evaluation', ...
        'Yes', 'No', 'Yes');

    switch choice2
        case 'Yes'

            AveragedStretchExps{n,6} = "Good" ; 

        case 'No'

            AveragedStretchExps{n,6} = "Needs Adjusted" ;

    end

    hold off ; 

end

save("Average Stretch Experiments - IP-PDMS.mat", "AveragedStretchExps") ;