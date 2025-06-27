function [NPD] = GridScan_BW_Vertical_v0(InitialGridBW, NextImage, ROI, PixelDiff)

% Set-Up Grid from ROI
GridYVector = ROI(1,1):1:ROI(2,1) ;
GridXVector = ROI(1,2):1:ROI(2,2) ;

% Adjust the Vertical Position of the Grid
GridYVector = GridYVector - PixelDiff  ;

% Find the Grid Positions to Evaluate (Black Pixels), from the Initial Grid 
[Rows, Cols] = find( InitialGridBW == 0 ) ;
NumRows = size(Rows,1) ;
Diff = zeros(NumRows,1) ;

% Generate the BW Grid from the Next Frame
NextGrid = NextImage(GridYVector,GridXVector) ;
NextGrid = HM_Binarize_v0(NextGrid, InitialGridBW, 0.01) ; 

for n = 1:1:NumRows

        Diff(n) = abs(InitialGridBW(Rows(n),Cols(n)) - NextGrid(Rows(n),Cols(n))) ;

end

%Compare the absolute difference between previous and next frames
GD = sum(Diff) ;
NPD = GD / NumRows ;

end