function CriticalPoints = StrainDeterminedCriticalPoints(Stress,Strain)

plot(Strain, Stress, 'linewidth', 3) ; hold on ;

dStress = diff(Stress) ;
dStrain = diff(Strain) ;

ddStress = [0 ; diff(diff(Stress))] ;
ddStrain = [0 ; diff(diff(dStrain))] ;
ddStrain = smooth(ddStrain) ;
ddStress = smooth(ddStress) ;

dStrain = [ 0 ; dStrain ] ;
dStress = [ 0 ; dStress ] ;
dStrain = smooth(dStrain) ;
dStress = smooth(dStress) ;

% Normalize Everthying
NormdStrain = normalize(dStrain) ;

% Find Peak of the dStrain
[~, locs] = findpeaks(smooth(smooth(NormdStrain))) ;
% Yield Point
YPIdx = locs(1) ;

YieldStress = Stress(YPIdx) ;
YieldStrain = Strain(YPIdx) ;
plot(YieldStrain, YieldStress, '+', 'Color', [158, 17, 50]/255, 'MarkerSize',10, 'LineWidth', 3) ;

% Find Peak of the dStrain
[~, locs2] = findpeaks(-smooth(smooth(NormdStrain))) ;

if isempty(locs2)
    locs2 = locs ; 
end

% Equilibrium Point
EPIdx = locs2(1) ;
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
