function [Data] = Fiber_Evaluation_v2(ROI_Top, ROI_Bottom, CurrentFrame, LastFiberGrid, InitialGridDetails, Grids)

% Intial Grid Details
IGWidth =  InitialGridDetails.Width*1.5 ;
IGTopCent = InitialGridDetails.TopCenter ;
IGBotCent = InitialGridDetails.BottomCenter ;
RowOffset = InitialGridDetails.EdgeRows ;

% Set Initial Grids, Accounting For Pattern Fitting Displacement
TopLine = ROI_Top(2,1) ;
BottomLine = ROI_Bottom(1,1) ;
GridY = TopLine:1:BottomLine ;
GridX = Grids.Fiber.Coordinates(1,2):1:Grids.Fiber.Coordinates(2,2) ; % Assume Fiber will be within the intial limits for duration of experiment

% Get Fiber Image
FiberImage = CurrentFrame(GridY,GridX) ;
% subplot(1,3,1) ; 
% imshow(FiberImage); 

% Binarize the Fiber Image using the Previous Fiber Image as a Reference
FiberGridBW = HM_Binarize_v1(FiberImage, LastFiberGrid, 0) ;
%FiberGridBW = HM_Binarize_v0(FiberImage, Grids.Fiber.InitialBW, 0) ; 

% subplot(1,3,2) ; 
% imshow(FiberGridBW); 

% Clean Fiber Grid
FiberGridBW = Binary_Grid_Clean_v3(FiberGridBW, 200, "") ;
[FiberGridBW, ~] = FiberImageFilling(FiberGridBW) ;
%FiberGridBW = Binary_Grid_Clean_v3(FiberGridBW, 200, "") ;
Data.FiberGridBW = FiberGridBW ;
FiberPixelCount = numel(find(FiberGridBW == 0)) ; % Grid Image Black Pixel Count

% subplot(1,3,3) ; 
% imshow(FiberGridBW); 

% Scan each row of the Fiber Image to find the edges and obtain a fiber line
Rows = size(FiberGridBW, 1) ;

for ScanRowNum = 1:1:Rows

    % Scan From Right
    ScanRow = FiberGridBW(ScanRowNum, :) ;
    [~, RightSideFiberPos] = find(ScanRow==0, 1, 'Last') ;
    [~, LeftSideFiberPos] = find(ScanRow==0, 1, 'First') ;

    if isempty(RightSideFiberPos) == 0 && isempty(LeftSideFiberPos) == 0

        if ScanRowNum < RowOffset

            RightSideFiberPos = IGTopCent + IGWidth/2 ;
            LeftSideFiberPos = IGTopCent - IGWidth/2 ; 

        elseif ScanRowNum > Rows-RowOffset

            RightSideFiberPos = IGBotCent + IGWidth/2 ;
            LeftSideFiberPos = IGBotCent - IGWidth/2 ;

        elseif RightSideFiberPos-LeftSideFiberPos > IGWidth*2

            CenterLast = (Fiber(ScanRowNum-1,1)+Fiber(ScanRowNum-1,2))/2 ;
            LeftSideFiberPos = CenterLast - IGWidth/2 ; 
            RightSideFiberPos = CenterLast + IGWidth/2 ; 

        end

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

% Finding the Average Width
WidthVector = Fiber(:,2) - Fiber(:,1) ;
AvgWidth = mean(WidthVector) ; 

%f = figure(); 
% imshow(FiberGridBW) ; hold on ;
% plot(Fiber(:,3), Fiber(:,4), '-b','linewidth',3);
% plot(FitFiberVector, Fiber(:,4), '-r','linewidth',3); hold off ;
% pause(0.2) ;
%close(f) ; 

if length(FitFiberVector) == Rows

    % Find the Length of the Fit Fiber Line
    for nn = 1:1:Rows-1
        diffx = abs(FitFiberVector(nn,1) - FitFiberVector(nn+1,1));
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
    Data.Fiber.AverageWidth = AvgWidth ; 
   
else

    Data = [] ;

end

end
