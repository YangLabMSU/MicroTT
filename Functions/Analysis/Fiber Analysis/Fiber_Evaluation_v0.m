function [Data] = Fiber_Evaluation_v0(ROI_Top, ROI_Bottom, CurrentFrame, LastFiberGrid, Grids)

% Set Initial Grids, Accounting For Pattern Fitting Displacement
TopLine = ROI_Top(2,1) ;
BottomLine = ROI_Bottom(1,1) ;
GridY = TopLine:1:BottomLine ;
GridX = Grids.Fiber.Coordinates(1,2):1:Grids.Fiber.Coordinates(2,2) ; % Assume Fiber will be within the intial limits for duration of experiment

% Get Fiber Image
FiberImage = CurrentFrame(GridY,GridX) ;

% Binarize the Fiber Image using the Previous Fiber Image as a Reference
FiberGridBW = HM_Binarize_v0(FiberImage, LastFiberGrid, 0) ;

% Clean Fiber Grid
FiberGridBW = Binary_Grid_Clean(FiberGridBW) ;
[FiberGridBW, ~] = FiberImageFilling(FiberGridBW) ;
FiberGridBW = Binary_Grid_Clean_v3(FiberGridBW, 200, "") ;
Data.FiberGridBW = FiberGridBW ; 
FiberPixelCount = numel(find(FiberGridBW == 0)) ; % Grid Image Black Pixel Count

% Scan each row of the Fiber Image to find the edges and obtain a fiber line
Rows = size(FiberGridBW, 1) ;

for ScanRowNum = 1:1:Rows

    % Scan From Right
    ScanRow = FiberGridBW(ScanRowNum, :) ;
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

imshow(FiberGridBW) ; hold on ; 
plot(Fiber(:,3), Fiber(:,4), '-b','linewidth',3); 
plot(FitFiberVector, Fiber(:,4), '-b','linewidth',3); hold off ;  
pause(0.2) ;

if length(FitFiberVector) == Rows

    % Find the Length of the Fit Fiber Line
    for nn = 1:1:Rows-1
        diffx = abs(FitFiberVector(nn,1) - FitFiberVector (nn+1,1));
        diffy = abs(Fiber(nn,4) - Fiber(nn+1,4));
        absdiff(nn) = sqrt( diffx^2 + diffy^2 ) ;
    end
    FitFiberLength = sum(absdiff);
    Fiber = [ Fiber FitFiberVector ] ;

    % Organize Data for Export
    Data.Fiber.FiberFrame = Fiber ;
    Data.Fiber.FiberFullFrame = Fiber + [ Grids.Fiber.Coordinates(1,2) Grids.Fiber.Coordinates(1,2) Grids.Fiber.Coordinates(1,2) TopLine Grids.Fiber.Coordinates(1,2)];
    Data.Fiber.Length = FitFiberLength ;
    Data.Fiber.PixelCount = FiberPixelCount ;

else

    Data = [] ;

end

end
