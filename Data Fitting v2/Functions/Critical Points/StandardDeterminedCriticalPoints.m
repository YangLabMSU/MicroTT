function CriticalPoints = StandardDeterminedCriticalPoints(Stress,Strain)

plot(Strain, Stress, 'linewidth', 3) ; hold on ; 

YPIdx = find(Strain <= 0.1, 1, 'last') ;
EPIdx = find(Strain <= 0.2, 1, 'last') ;

YieldStress = Stress(YPIdx) ;
YieldStrain = Strain(YPIdx) ;
plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

EqStress = Stress(EPIdx) ;
EqStrain = Strain(EPIdx) ;
plot(EqStrain, EqStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

if Strain(end) > 0.5
    % Find 50% Strain Point
    FPSPIdx = find(Strain >= 0.5, 1, 'first') ;
    FPStress = Stress(FPSPIdx) ;
    FPStrain = Strain(FPSPIdx) ;
    plot(FPStrain, FPStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;
else
    FPSPIdx = size(Strain,1) ; 
    FPStress = Stress(end) ;
    FPStrain = Strain(end) ;
    plot(FPStrain, FPStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;
end

CriticalPoints = [YPIdx, EPIdx, FPSPIdx] ; 

end
