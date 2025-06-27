% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;

Exps = [ 9 10 ] ; 

for n = 1:size(Exps,2) 

    figure() ; 
    Stress = AveragedStretchExps{Exps(n), 2} ; 
    Strain = AveragedStretchExps{Exps(n), 3} ; 

    plot(Strain, Stress) ; hold on ; 

end
