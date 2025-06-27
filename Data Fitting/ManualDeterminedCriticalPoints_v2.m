function CriticalPoints = ManualDeterminedCriticalPoints_v2(Stress,Strain)

plot(Strain, Stress, 'linewidth', 3) ; hold on ;

[x(1),~] = ginput(1) ;
YieldPoint = x(1) ;
[~, YPIdx] = min(abs(Strain - YieldPoint)) ;

YieldStress = Stress(YPIdx) ;
YieldStrain = Strain(YPIdx) ;
plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

[x(2),~] = ginput(1) ;
EqualPoint = x(2) ;
[~, EPIdx] = min(abs(Strain - EqualPoint)) ;

EqStress = Stress(EPIdx) ;
EqStrain = Strain(EPIdx) ;
plot(EqStrain, EqStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

% FPStress = (EqStress + max(Stress)) / 2 ;
FPStrain = (EqStrain + max(Strain)) / 2 ;
FPSPIdx = find(Strain >= FPStrain, 1, 'first') ;
FPStress = Stress(FPSPIdx) ;
FPStrain = Strain(FPSPIdx) ;
plot(FPStrain, FPStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

CriticalPoints = [YPIdx, EPIdx, FPSPIdx] ;

end
