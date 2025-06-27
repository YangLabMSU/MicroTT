clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Ogden Experiments - v1.mat') ;
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

load('Average Ogden Experiments - v1 - Table.mat') ;

R2 = [] ; 
Exps = [] ; 
for n = 1:size(AveragedStretchExps,1)

    ErrorStats = AveragedStretchExps{n,8} ; 
    NumExps = size(ErrorStats,1) ; 

    R2 = [ R2 ; ErrorStats(:,1) ] ; 
    Exps = [ Exps ; NumExps ] ; 

end

Mean_R2 = mean(R2) ; 
Std_R2 = std(R2) ; 

ExpNum = sum(Exps) ; 

disp([ "Number of Experiments: ", ExpNum " , R^2 Values: " Mean_R2 "+-" Std_R2 ]) ; 
