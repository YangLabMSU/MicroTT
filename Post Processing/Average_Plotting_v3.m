clear ; clc ; close ;

% Plotting Average Results
load('Experiment Averages.mat') ;

PlotFig = figure() ;
PlotFig.Units = 'Normalized' ;
PlotFig.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;

LegendS = [] ; 
LegendDip = [] ; 
LegendVisio = [] ; 
VisCol = 255 ; 
DipCol = 255 ; 
SCol = 255 ; 


for n = 1:size(averagedResults,1)

    ParamVec = averagedResults{n,1}(1,:) ;
    Material = ParamVec(1) ;
    Power = ParamVec(8) ;
    Speed = ParamVec(9) ;
    Width = ParamVec(10) ;
    Height = ParamVec(11) ;
    Slice = ParamVec(12) ;
    Hatch = ParamVec(13) ;
    Style = ParamVec(14) ;
    FiberArea = ParamVec(15) ;
    Rate = ParamVec(18) ;


    Details = sprintf("Power: %s, Speed: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s, Rate: %s, Area: %s", ...
        Power, Speed, Width, Height, Slice, Hatch, Style, Rate, FiberArea) ;

    if averagedResults{n,6} == "Needs Adjusted"

        % Average Plotting
        StressStd = averagedResults{n,9}(:,2) ;
        Stress = averagedResults{n,9}(:,1) ;

        StrainStd = averagedResults{n,10}(:,2) ;
        Strain = averagedResults{n,10}(:,1) ;

    else

        % Average Plotting
        StressStd = averagedResults{n,4}(:,2) ;
        Stress = averagedResults{n,4}(:,1) ;

        StrainStd = averagedResults{n,5}(:,2) ;
        Strain = averagedResults{n,5}(:,1) ;

    end

    if Material == "IP-S"

        color = [ 100 255-SCol SCol ] ./ 255 ; 
        SCol = SCol - 10 ; 
        LegendS = [ LegendS ; Details ] ;

        subplot(1,3,1) ;
        plot(Strain, Stress, 'LineWidth', 3, 'Color', color ) ; hold on ;
        legend(LegendS, 'Location','southoutside') ;

    elseif Material == "IP-Dip"

        color = [ 100 255-DipCol DipCol ] ./ 255  ;
        DipCol = DipCol - 20 ; 
        LegendDip = [ LegendDip ; Details ] ;

        subplot(1,3,2) ;
        plot(Strain, Stress, 'LineWidth', 3, 'Color', color ) ; hold on ;
        legend(LegendDip, 'Location','southoutside') ;

    elseif Material == "IP-Visio"
        
        color = [ 100 255-VisCol VisCol ] ./ 255 ; 
        VisCol = VisCol - 15 ; 
        LegendVisio = [ LegendVisio ; Details ] ;

        subplot(1,3,3) ;
        plot(Strain, Stress, 'LineWidth', 3, 'Color', color ) ; hold on ;
        legend(LegendVisio, 'Location','southoutside') ;

    end



end