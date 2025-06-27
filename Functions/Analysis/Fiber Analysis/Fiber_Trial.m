clear ; clc ; close ; 
load('J:\Users\User1\Documents\Yang Research\TPP Tensile Testing\Analysis Code\DIC v10 - 9-20-23\Functions\Analysis\Fiber Analysis\Trial Data.mat');

% Fiber
%FiberData = TPP_TensileTesting_Fiber_Evaluation_v5( ROI_Top{FrameCount+1,1}, ROI_Bottom{FrameCount+1,1}, Grids, NextFrame_Enhanced, PixelCount) ;

% Set Initial Grids, Accounting For Pattern Fitting Displacement
TopLine = TrialData.ROI_Top(2,1) ;
BottomLine = TrialData.ROI_Bottom(1,1) ;

GridY = TopLine:1:BottomLine ;
GridX = TrialData.Grids.Fiber.Coordinates(1,2):1:TrialData.Grids.Fiber.Coordinates(2,2) ;

% Get Fiber Grid and make it BW
FiberGrid = TrialData.NextFrame(GridY,GridX) ;
FiberGridBW = HM_Binarize_By_Pixel_Count(FiberGrid, 1, TrialData.Grids.Fiber.nset, round(TrialData.Grids.Fiber.IBPCount)) ;

[ FiberContour, FiberContourPixelCount ] = TPP_TensileTesting_Fiber_Countour_Finder_v8(FiberGridBW, TrialData.FiberPixelCount) ;

