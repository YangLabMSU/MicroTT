function [] = TPP_TensileTesting_AnalysisPlotUpdate_v3(NextFrame, ROI_Top, ROI_Bottom, Data, FrameNumber, TotalFrames)
FrameVector = Data.VideoFrame(:,2) ; 

% Subplot Size
SPRows = 6 ; 
SPCols = 3 ; 

RectColor = '#10aacc' ; 
RectWidth = 2 ;

FiberColor = '#059e05' ; 
FiberLineWidth = 3 ; 

EdgeLineColor = '#e01010' ; 
EdgeLineWidth = 2 ; 
EdgeLineX = [ROI_Top(1,2) ROI_Top(2,2)] ; 
TopEdgeLine = [Data.TopStructure.EdgeLine(FrameNumber) Data.TopStructure.EdgeLine(FrameNumber)] ; 
BottomEdgeLine = [Data.BottomStructure.EdgeLine(FrameNumber) Data.BottomStructure.EdgeLine(FrameNumber)] ; 

RawLineColor = '#3aa4c7' ; 
AdjustedLineColor = '#b33636' ; 
PlotLineWidth = 2 ; 

% Show Image with Pattering Tracking overlay
subplot(SPRows, SPCols, [ 1 4 7 10 13 ]) ; 
imshow(NextFrame) ; 
hold on; 
DrawRectangleGrid_v2(ROI_Top, RectColor, RectWidth) ; 
DrawRectangleGrid_v2(ROI_Bottom, RectColor, RectWidth) ;
plot(Data.Fiber.FiberFullFrame{FrameNumber,1}(:,5), Data.Fiber.FiberFullFrame{FrameNumber,1}(:,4), '-', 'color', FiberColor, 'LineWidth', FiberLineWidth) ;
plot(EdgeLineX, TopEdgeLine, '-', 'color', EdgeLineColor, 'LineWidth', EdgeLineWidth) ; 
plot(EdgeLineX, BottomEdgeLine, '-', 'color', EdgeLineColor, 'LineWidth', EdgeLineWidth) ; 
hold off ;

% Show Top Displacement
subplot(SPRows, SPCols, [ 2 3 5 6 ]) ; 
plot(FrameVector, Data.TopStructure.SumDisplacementY, '-', 'color', RawLineColor,'LineWidth', PlotLineWidth) ; hold on ; 
plot(FrameVector, Data.TopStructure.SumDisplacementYAdjusted, '-', 'color', AdjustedLineColor,'LineWidth', PlotLineWidth) ; hold off ; 
title('Top Structure Displacement','units', 'normalized', 'Position',  [ 0.88 0.865 0 ]) ;
ylabel("Displacement (Pixels)")
legend({'Raw','Adjusted'},'Location','northwest') ; 
legend('boxoff') ; 

% Show Bottom Displacement
subplot(SPRows, SPCols, [ 8 9 11 12 ]) ; 
plot(FrameVector, Data.BottomStructure.SumDisplacementY, '-', 'color', RawLineColor,'LineWidth', PlotLineWidth) ; hold on ; 
plot(FrameVector, Data.BottomStructure.SumDisplacementYAdjusted, '-', 'color', AdjustedLineColor,'LineWidth', PlotLineWidth) ; hold on ; 
title('Bottom Structure Displacement','units', 'normalized', 'Position',  [ 0.875 0.865 0 ]) ;
ylabel("Displacement (Pixels)")
legend({'Raw','Adjusted'},'Location','northwest') ; 
legend('boxoff') ;  

% Show Fiber Length
subplot(SPRows, SPCols, [ 14 15 17 18 ]) ; 
plot(FrameVector, Data.Fiber.Length, '-', 'color', RawLineColor,'LineWidth', PlotLineWidth) ; hold on ; 
plot(FrameVector, Data.Fiber.LengthAdjusted, '-', 'color', AdjustedLineColor,'LineWidth', PlotLineWidth) ; hold off ; 
ylabel("Length (Pixels)")
xlabel("Frame Number", 'FontSize', 15)
legend({'Raw', 'Adjusted'},'Location','northwest') ; 
legend('boxoff') ; 
title('Fiber Length','units', 'normalized', 'Position',  [ 0.94 0.865 0 ]) ; 

% Show Progress Bar
ProgressBarX = [0 FrameVector(end)] ; 
ProgressBarY = [1 1] ;
subplot(SPRows, SPCols, 16) ;
area(ProgressBarX, ProgressBarY, 'facecolor', '#4f169e') ; 
xlim([0 TotalFrames]) ; 
ylim([0 1]) ;
title(sprintf("Progress: %d / %d", FrameVector(end), TotalFrames)) ; 
xlabel("Frame Progress") ; 
set(gca,'YTickLabel',[]); hold off ;

% Update Plot
drawnow ; 

end