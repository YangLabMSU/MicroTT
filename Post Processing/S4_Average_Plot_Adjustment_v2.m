clear ; clc ; close ;

% load('Average Stretch Experiments.mat') ; 
load('Average Stretch Experiments - Sub 6-5-24.mat') ; 

% Average Plotting Adjustments
PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;

for n = 1:size(AveragedStretchExps,1)

    if AveragedStretchExps{n,6} == "Needs Adjusted"

        Check = 0 ;
        % Plot Individual Experiments
        ExperimentLists = AveragedStretchExps{n,1} ;
        IndStress = AveragedStretchExps{n,2} ;
        IndStrain = AveragedStretchExps{n,3} ;

        while Check == 0

            LegendLength = size(IndStress,2) ;
            LegendNum = string((1:1:LegendLength)) ;

            plot(IndStrain, IndStress, 'LineWidth', 2) ;  hold on ;
            legend(LegendNum) ;

            % Create list of curve options
            curveOptions = cell(1, LegendLength);
            for i = 1:LegendLength
                curveOptions{i} = sprintf('Curve %d', i);
            end

            curveOptions{i+1} = 'Looks Good' ;

            % Prompt user to select curves for removal (multi-select)
            [selection, ~] = listdlg('PromptString', 'Select curves to remove:', ...
                'SelectionMode', 'multiple', ...
                'ListString', curveOptions, 'InitialValue', i+1);

            % Check if any curves were selected for removal
            if isempty(selection)
                removedCurves = [];
                Check = 1 ;

            elseif selection == size(curveOptions,2)

                AvgStress = mean(IndStress,2) ;
                StdStress = std(IndStress,1,2);
                AvgStrain = mean(IndStrain,2) ;
                StdStrain = std(IndStrain,1,2);

                AveragedStretchExps{n, 1} = ExperimentLists ; 
                AveragedStretchExps{n, 2} = IndStress ;
                AveragedStretchExps{n, 3} = IndStrain ;
                AveragedStretchExps{n, 4} =  [ AvgStress StdStress ] ;
                AveragedStretchExps{n, 5} = [ AvgStrain StdStrain ] ;
                AveragedStretchExps{n, 6} = "Good" ;

                Check = 1 ;
                hold off ; 

            else

                % Get indices of selected curves and remove them from data matrix
                removedCurves = selection ;
                ExperimentLists(removedCurves, :) = [] ;                
                IndStress(:, removedCurves) = [] ;
                IndStrain(:, removedCurves) = [] ;

                hold off ;

            end

        end
    end


end

% save("Average Stretch Experiments - Sub 6-5-24.mat", "AveragedStretchExps") ;
