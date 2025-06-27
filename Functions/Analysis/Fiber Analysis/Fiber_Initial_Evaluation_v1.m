function [IFGDets] = Fiber_Initial_Evaluation_v1(InitialFiberGridBW)

% Scan each row of the Fiber Image to find the edges and obtain a fiber line
Rows = size(InitialFiberGridBW, 1) ;

for ScanRowNum = 1:1:Rows

    % Scan From Right
    ScanRow = InitialFiberGridBW(ScanRowNum, :) ;
    [~, RightSideFiberPos] = find(ScanRow==0, 1, 'Last') ;
    [~, LeftSideFiberPos] = find(ScanRow==0, 1, 'First') ;

    if isempty(RightSideFiberPos) == 0 && isempty(LeftSideFiberPos) == 0

        FiberLine = mean([RightSideFiberPos LeftSideFiberPos]) ;
        Fiber(ScanRowNum,:) = [ LeftSideFiberPos, RightSideFiberPos, FiberLine, ScanRowNum] ;

    end

end

Fiber(:,3) = smooth(mean([smooth(Fiber(:,1),10) smooth(Fiber(:,2),10) ], 2),10) ;

% Fit the Fiber Line
FiberLineFit = Fiber(:,3) ;
FiberLineFitX = Fiber(:,4) ;
FiberLineFitX = (FiberLineFitX - FiberLineFitX(1)) -  (FiberLineFitX(end)/2) ;

% Perform Gaussian curve fitting
gaussian_fit = fit(FiberLineFitX, FiberLineFit, 'fourier2');
FitFiberVector = feval(gaussian_fit, FiberLineFitX) ;

% imshow(InitialFiberGridBW) ; hold on ; 
% plot(Fiber(:,1), Fiber(:,4), '-r', 'linewidth', 2) ; 
% plot(Fiber(:,2), Fiber(:,4), '-r', 'linewidth', 2) ;
% plot(Fiber(:,3), Fiber(:,4), '-b','linewidth',3); 
% plot(FitFiberVector, Fiber(:,4), '-b','linewidth',3); %hold off ;  
% pause(0.2) ;

EdgePortions = round(0.1*Rows) ;

% Finding the Average Width
WidthVector = Fiber(:,2) - Fiber(:,1) ;

AvgWidth = mean(WidthVector) ; 
TopCenter = round(mean(Fiber(1:EdgePortions, 3))) ; 
BottomCenter = round(mean(Fiber(end-EdgePortions:end,3))) ; 

Left = [ TopCenter BottomCenter ] - 1.2*(AvgWidth/2) ; 
Right =  [ TopCenter BottomCenter ] + 1.2*(AvgWidth/2) ; 
Height = [ 0 Rows ] ;

% plot(Left, Height, '-c', 'linewidth', 2) ; 
% plot(Right, Height, '-c', 'linewidth', 2) ; 

% Initial Grid Output
IFGDets.Width = AvgWidth ; % Initial Fiber Grid Dets
IFGDets.TopCenter = TopCenter ; 
IFGDets.BottomCenter = BottomCenter ; 
IFGDets.EdgeRows = EdgePortions ; % Number of Rows on top and bottom initially 10% 

end
