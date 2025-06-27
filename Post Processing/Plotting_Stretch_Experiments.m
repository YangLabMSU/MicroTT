clear ; clc ; close ;

% Use the Experiment Table to Plot the Experiments
load('All Experiments Table.mat') ;
i = 1 ; 

for n = 2:size(AllExperimentTable,1)

    path = AllExperimentTable(n,27) ;
    load(path) ;

    if isfield(ProcessedData, 'StretchIdx')

        StretchIdx = round(ProcessedData.StretchIdx(1)):1:round(ProcessedData.StretchIdx(2)) ; 

        % disp('The variable Stretch Idx exists.');
        StrainData = ProcessedData.PlateStrain(StretchIdx) - ProcessedData.PlateStrain(StretchIdx(1)) ;  
        StressData = ProcessedData.Stress(StretchIdx) - ProcessedData.Stress(StretchIdx(1)) ; 

        if ProcessedData.Parameters.Material == "IP-S"

            subplot(1,4,1) ;
            plot(StrainData, StressData) ; hold on ;

            subplot(1,4,4) ;
            plot(StrainData, StressData, '-r') ; hold on ;
            

        elseif ProcessedData.Parameters.Material == "IP-Dip"

            subplot(1,4,2) ;
            plot(StrainData, StressData) ; hold on ;

            subplot(1,4,4) ;
            plot(StrainData, StressData, '-g') ; hold on ;

        elseif ProcessedData.Parameters.Material == "IP-Visio"

            subplot(1,4,3) ;
            plot(StrainData, StressData) ; hold on ;

            subplot(1,4,4) ;
            plot(StrainData, StressData, '-b') ; hold on ;


        end

        i = i + 1 ; 
       

    else

        % disp('The variable does not exist.');

    end


end
disp(i) ; 