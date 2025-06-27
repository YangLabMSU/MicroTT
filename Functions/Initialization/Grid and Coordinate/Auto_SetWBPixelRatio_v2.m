function [Grids] = Auto_SetWBPixelRatio_v2(Grids, AutoTemplate)

% Load in Initial Grids - Top 
TGI = Grids.TopStructure.Initial ; % Top Grid Initial
TGTBW = AutoTemplate.BWImages.TopPlatform.InitialBW ; 

% Binarize Initial Grid - Top
Grids.TopStructure.InitialBW = HM_Binarize_Threshold_Adjust(TGI, TGTBW) ;

% Clean Initial Grid - Top 
Grids.TopStructure.InitialBW = Binary_Grid_Clean(Grids.TopStructure.InitialBW) ; 


% Load in Initial Grids - Bottom
BGI = Grids.BottomStructure.Initial ; % Top Grid Initial
BGTBW = AutoTemplate.BWImages.BottomPlatform.InitialBW ; 

% Binarize Initial Grid - Bottom
Grids.BottomStructure.InitialBW = HM_Binarize_Threshold_Adjust(BGI, BGTBW) ;

% Clean Initial Grid - Bottom 
Grids.BottomStructure.InitialBW = Binary_Grid_Clean(Grids.BottomStructure.InitialBW) ; 


% Load in Initial Grids - Fiber
FGI = Grids.Fiber.Initial ; % Top Grid Initial
FGTBW = AutoTemplate.BWImages.Fiber.InitialBW ; 

% Binarize Initial Grid - Fiber
Grids.Fiber.InitialBW = HM_Binarize_Threshold_Adjust(FGI, FGTBW) ;

% Clean Initial Grid - Fiber
Grids.Fiber.InitialBW = Binary_Grid_Clean(Grids.Fiber.InitialBW) ; 
[Grids.Fiber.InitialBW, ~] = FiberImageFilling(Grids.Fiber.InitialBW) ; 


% Top Grids, Right and Left
[~, TGCols] = size(Grids.TopStructure.InitialBW) ; 
TLCoords = Grids.TopLeftStructure.Coordinates ; 
TLCoords = [ 1 1 ; (TLCoords(2,1)-TLCoords(1,1)), (TLCoords(2,2)-TLCoords(1,2)) ] ; 
Grids.TopLeftStructure.InitialBW = Grids.TopStructure.InitialBW(TLCoords(1,1):1:TLCoords(2,1), TLCoords(1,2):1:TLCoords(2,2)) ;

TRCoords = Grids.TopRightStructure.Coordinates ;
TRCoords = [ 1 (TGCols-(TRCoords(2,2)-TRCoords(1,2))) ; (TRCoords(2,1)-TRCoords(1,1)),  TGCols] ;
Grids.TopRightStructure.InitialBW = Grids.TopStructure.InitialBW(TRCoords(1,1):1:TRCoords(2,1), TRCoords(1,2):1:TRCoords(2,2)) ;


% Bottom Grids, Right and Left
[~, BGCols] = size(Grids.TopStructure.InitialBW) ; 
BLCoords = Grids.BottomLeftStructure.Coordinates ; 
BLCoords = [ 1 1 ; (BLCoords(2,1)-BLCoords(1,1)), (BLCoords(2,2)-BLCoords(1,2)) ] ; 
Grids.BottomLeftStructure.InitialBW = Grids.BottomStructure.InitialBW(BLCoords(1,1):1:BLCoords(2,1), BLCoords(1,2):1:BLCoords(2,2)) ;

BRCoords = Grids.BottomRightStructure.Coordinates ;
BRCoords = [ 1 (BGCols-(BRCoords(2,2)-BRCoords(1,2))) ; (BRCoords(2,1)-BRCoords(1,1)),  BGCols] ;
Grids.BottomRightStructure.InitialBW = Grids.BottomStructure.InitialBW(BRCoords(1,1):1:BRCoords(2,1), BRCoords(1,2):1:BRCoords(2,2)) ;



end