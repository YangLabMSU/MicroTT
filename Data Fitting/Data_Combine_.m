clear ; clc ; close ;

load('IP-S Fit Values for Comparison.mat') ;
load('Average Stretch Experiments Fits - Sub 6-14.mat') ;

Data = [] ;

for n = 1:size(AveragedStretchExps,1)

    ModLam = AveragedStretchExps{n,7} ;
    Strn = AveragedStretchExps{n,8} ;

    Data = [ Data ; ModLam Strn ] ;

    clear ModLam Strn ;

end

IPSFitValues = [ IPSFitValues ; Data ] ; 

save("IP-S Fit Values for Comparison - v2.mat", "IPSFitValues") ;