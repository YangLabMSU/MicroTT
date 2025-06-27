clear ; clc ; close ;

% Plotting Average Results
% load('Average Stretch Experiments.mat') ; 
load('Average Stretch Experiments - Sub 6-5-24.mat') ; 

newcolors = [ 184 103 103 ; 184 51 51 ; 184 9 9 ; 225 227 100 ; 221 224 16 ;...
180 242 119 ; 112 186 37 ; 13 166 39 ; 56 156 73 ; 64 102 71 ; 131 247 236 ;...
 41 179 165 ;  6 117 106 ; 89 172 240 ; 27 106 171 ; 3 60 107 ; 81  63 242 ;...
 18  5  135 ; 244 77 250 ; 123 6 128  ; 255 15 87 ]./255 ; 

PlotFig1 = figure() ;
PlotFig1.Units = 'Normalized' ;
PlotFig1.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
colormap(PlotFig1,'jet') ; 
LineStyleOrder = ["-"; "--"; "-o"; "-." ; "."] ;
colororder(newcolors) ; 

PlotFig2 = figure() ;
PlotFig2.Units = 'Normalized' ;
PlotFig2.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
colormap(PlotFig2,'jet') ;
LineStyleOrder = ["-"; "--"; "-o"; "-." ; "."] ;
colororder(newcolors) ; 

PlotFig3 = figure() ;
PlotFig3.Units = 'Normalized' ;
PlotFig3.Position = [ 0.085, 0.10, 0.8, 0.8 ] ;
colormap(PlotFig3,'jet') ;
ax = gca ; 
LineStyleOrder = ["-"; "--"; "-o"; "-." ; "."] ;
colororder(newcolors) ; 

LegendS = [] ; 
LegendDip = [] ; 
LegendVisio = [] ; 
VisCol = 255 ; 
DipCol = 255 ; 
SCol = 255 ; 

IPS_Count = 1 ; 
IPDip_Count = 1 ; 
IPVis_Count = 1 ; 

color = "parula" ; 

for n = 1:size(AveragedStretchExps,1)

    ParamVec = AveragedStretchExps{n,1}(1,:) ;
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

    if AveragedStretchExps{n,6} == "Needs Adjusted"

        % Average Plotting
        StressStd = AveragedStretchExps{n,10}(:,2) ;
        Stress = AveragedStretchExps{n,10}(:,1) ;

        StrainStd = AveragedStretchExps{n,11}(:,2) ;
        Strain = AveragedStretchExps{n,11}(:,1) ;

    else

        % Average Plotting
        StressStd = AveragedStretchExps{n,4}(:,2) ;
        Stress = AveragedStretchExps{n,4}(:,1) ;

        StrainStd = AveragedStretchExps{n,5}(:,2) ;
        Strain = AveragedStretchExps{n,5}(:,1) ;

    end

    if Material == "IP-S"        

        LegendS = [ LegendS ; Details ] ;
        figure(PlotFig1) ;
        plot(Strain, Stress, 'LineWidth', 3) ; hold on ;       
        legend(LegendS, 'Location','eastoutside') ;
        title("IP-S Averages") ; 

    elseif Material == "IP-Dip"
       
        LegendDip = [ LegendDip ; Details ] ;
        figure(PlotFig2) ;
        plot(Strain, Stress, 'LineWidth', 3) ; hold on ;    
        legend(LegendDip, 'Location','eastoutside') ;
        title("IP-Dip Averages") ; 

    elseif Material == "IP-Visio"
        
        LegendVisio = [ LegendVisio ; Details ] ;
        figure(PlotFig3) ;
        plot(Strain, Stress, 'LineWidth', 3) ; hold on ;
        legend(LegendVisio, 'Location','eastoutside') ;
        title("IP-Visio Averages")

    end


end

