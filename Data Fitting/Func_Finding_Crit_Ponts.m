% Breaking down and fitting the stress strain curve

load('All Stretch Experiments Table.mat') ;
Details = AllStretchExperimentTable(2:end,:) ; 
load('All Stretch Experiment Data.mat') ; 

for n = 1:25 %:size(StretchExperimentData,1)      

    Stress = StretchExperimentData{n,2} ; 
    Strain = StretchExperimentData{n,3} ;

    dStress = diff(Stress) ; 
    dStrain = diff(Strain) ;

    plot(Strain, Stress, 'linewidth', 3) ;
    % 
    % ddStress = diff(diff(Stress)) ; 
    % ddStrain = diff(diff(dStrain)) ; 
    % ddStrain = smooth(ddStrain) ; 
    % ddStress = smooth(ddStress) ; 
    % 
    % dStrain = smooth(dStrain) ; 
    % dStress = smooth(dStress) ;
    % 
    % index = find(( dStress(1:end-1) == 0 | (dStress(1:end-1) > 0 & dStress(2:end) < 0)), 1);
    % 
    % if isempty(index) 
    % 
    %     [~,index] = min(dStress) ; 
    % 
    % end


    plot(Stress,'linewidth',3) ; hold on ;
    % plot(dStress*10,'linewidth', 3) ; 
    % plot(ddStress*100, 'linewidth', 3) ; 
    % plot(Strain, Stress, '-b', 'LineWidth', 3) ; hold on ;
    plot(Strain(IPIDX), Stress(IPIDX), 'xr', 'linewidth', 3, 'markersize', 10) ; 

    pause(2) ; 
    hold off ; 

end


    % % Normalize Everthying
    % 
    % NormStress = normalize(Stress) ; 
    % NormStrain = normalize(Strain) ; 
    % NormdStress = normalize(dStress) ;  
    % NormdStrain = normalize(dStrain) ;  
    % NormddStrain = normalize(ddStrain) ; 
    % NormddStress = normalize(ddStress) ; 
    % 
    % subplot(3,2,1) ;
    % plot(Stress, '-b', 'LineWidth', 3) ;
    % subplot(3,2,3) ;
    % plot(dStress, '-b', 'LineWidth', 3) ;
    % subplot(3,2,5) ;
    % plot(ddStress, '-b', 'LineWidth', 3) ;
    % 
    % subplot(3,2,2) ;
    % plot(Strain, '-c', 'LineWidth', 3) ;
    % subplot(3,2,4) ;
    % plot(dStrain, '-c', 'LineWidth', 3) ;
    % subplot(3,2,6) ;
    % plot(ddStrain, '-c', 'LineWidth', 3) ;


