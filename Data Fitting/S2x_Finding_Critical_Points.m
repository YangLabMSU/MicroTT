clear ; clc ; close ;

% Need to Determine the Critical Points for All Stretch Experiments (if applicable)
load('All Stretch Experiments Table.mat') ;
Details = AllStretchExperimentTable(2:end,:) ;
load('All Stretch Experiment Data.mat') ;

PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
%%

for n = 1:size(StretchExperimentData,1)

    Stress = StretchExperimentData{n,2} ;
    Strain = StretchExperimentData{n,3} ;   
    
    CriticalPoints = StandardDeterminedCriticalPoints(Stress,Strain) ;

    check1 = questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
        "Yes", "No", "Yes") ;

    switch check1
        case "Yes"

            StretchExperimentData{n,4} = CriticalPoints ;

        case "No"

            hold off ;
            CriticalPoints = StressDeterminedCriticalPoints(Stress,Strain) ;

            check2 = questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
                "Yes", "No", "Yes") ;

            switch check2
                case "Yes"

                    StretchExperimentData{n,4} = CriticalPoints ;

                case "No"

                    hold off ;
                    CriticalPoints = StrainDeterminedCriticalPoints(Stress,Strain) ;

                    check3 = questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
                        "Yes", "No", "Yes") ;

                    switch check3
                        case "Yes"

                            StretchExperimentData{n,4} = CriticalPoints ;

                        case "No"

                            CriticalPoints = ManualDeterminedCriticalPoints(Stress,Strain) ;

                            check4 = questdlg("Does the Critical Point Selection Look good?","Critical Point Selection",...
                                "Yes", "No", "Yes") ;

                            switch check4
                                case "Yes"

                                    StretchExperimentData{n,4} = CriticalPoints ;

                                case "No"

                                    CriticalPoints = "Adjust Fit Style" ;
                                    StretchExperimentData{n,4} = CriticalPoints ;

                            end


                    end

            end

    end

    hold off ;

end

