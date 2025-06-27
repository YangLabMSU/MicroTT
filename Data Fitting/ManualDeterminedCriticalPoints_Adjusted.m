function CriticalPoints = ManualDeterminedCriticalPoints_Adjusted(Stress,Strain)

plot(Strain, Stress, 'linewidth', 3) ; hold on ; 

[x,~] = ginput(2) ;
YieldPoint = x(1) ;
EqualPoint = x(2) ;
[~, YPIdx] = min(abs(Strain - YieldPoint)) ;
[~, EPIdx] = min(abs(Strain - EqualPoint)) ;

YieldStress = Stress(YPIdx) ;
YieldStrain = Strain(YPIdx) ;
plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

EqStress = Stress(EPIdx) ;
EqStrain = Strain(EPIdx) ;
plot(EqStrain, EqStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

CriticalPoints = [YPIdx, EPIdx] ; 

end
