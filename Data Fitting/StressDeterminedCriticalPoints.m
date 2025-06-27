function CriticalPoints = StressDeterminedCriticalPoints(Stress,Strain)

plot(Strain, Stress, 'linewidth', 3) ; hold on ;

SF = round(0.1*size(Stress,1)) ;
dStress = smooth(smooth(Stress,SF), SF) ;

YPIdx = find(( dStress(1:end-1) == 0 | (dStress(1:end-1) > 0 & dStress(2:end) < 0)), 1) ;

if isempty(YPIdx)

    [~,StrLim] = find(Strain >= 0.25, 1, 'First') ; 
    [~,YPIdx] = min(dStress(1:StrLim)) ;
   
end

YieldStress = Stress(YPIdx) ;
YieldStrain = Strain(YPIdx) ; 
plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ; hold on ; 

EPIdx = find(( dStress(YPIdx:end-1) == 0 | (dStress(YPIdx:end-1) < 0 & dStress(YPIdx+1:end) > 0)), 1) ;

if isempty(YPIdx)

    EqStrain = YieldStrain+0.05 ; 
    [~,EPIdx] = find(Strain >= EqStrain, 1, 'First') ; 
   
end

EqStrain = Strain(EPIdx) ;
EqStress = Stress(EPIdx) ; 
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

