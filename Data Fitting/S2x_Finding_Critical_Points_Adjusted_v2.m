% clear ; clc ; close ;
%
% % Need to Determine the Critical Points for All Stretch Experiments (if applicable)
% load('All Stretch Experiments Table.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ;
% load('All Stretch Experiment Data.mat') ;

% load('All Stretch Experiments Table - Sub 6-14.mat') ;
% Details = AllStretchExperimentTable(2:end,:) ; 
% load('All Stretch Experiment Data - Sub 6-14.mat') ; 

load('All IPS Hatch - Sub 6-5-24 - Table.mat') ;  
Details = AllStretchExperimentTable(2:end,:) ; 
load('All IPS Hatch - Sub 6-5-24 - Data.mat') ; 

% load('Stretch Experiment Data Fit.mat') ;


PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.3, 0.10, 0.5, 0.8 ] ;


for n = 1:size(StretchExperimentData,1)

    if string(StretchExperimentData{n,4}) == "Adjust Fit Style"

        Stress = StretchExperimentData{n,2} ;
        Strain = StretchExperimentData{n,3} ;

        plot(Strain, Stress, 'linewidth', 3) ; hold on ;

        check1 = questdlg("Can it be properly fit?","Curve Check",...
            "Yes", "No", "Yes") ;

        switch check1
            case "Yes"
                check = 0 ; 
                while check == 0

                    CriticalPoints = ManualDeterminedCriticalPoints_Adjusted(Stress,Strain) ;

                    check2= questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
                        "Yes", "No", "Yes") ;

                    switch check2
                        case "Yes"

                            check = 1 ;
                            StretchExperimentData{n,4} = CriticalPoints ;

                        case "No"


                    end
                end

            case "No"

                CriticalPoints = "Atypical Curve" ;
                StretchExperimentData{n,4} = CriticalPoints ;

        end



    end

    hold off ;

end


