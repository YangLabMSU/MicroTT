function [TopAdjustment, BottomAdjustment] = TPP_TensileTesting_Edge_Adjustment_Filter_v2( Grids, ROI_Top, ROI_Bottom, NextFrame, Pixels2Find)

Pixels2Count = Pixels2Find + 3 ; 

% Set-Up Grid from ROI
TopGridY = ROI_Top(1,1):1:ROI_Top(2,1) ;
BottomGridY = ROI_Bottom(1,1):1:ROI_Bottom(2,1) ;
RightGridX = Grids.BottomRightStructure.Coordinates(1,2):1:Grids.BottomRightStructure.Coordinates(2,2) ;
LeftGridX = Grids.BottomLeftStructure.Coordinates(1,2):1:Grids.BottomLeftStructure.Coordinates(2,2) ;

% Define The Grids
TopLeft = NextFrame(TopGridY, LeftGridX); 
BottomLeft = NextFrame(BottomGridY, LeftGridX) ; 
TopRight = NextFrame(TopGridY, RightGridX) ; 
BottomRight = NextFrame(BottomGridY, RightGridX) ;

% Make the Grids BW 
Grids.TopLeftStructure.nset = 0.5 ; 
Grids.TopRightStructure.nset = 0.5 ;
Grids.BottomLeftStructure.nset = 0.5 ;
Grids.BottomRightStructure.nset = 0.5 ;

TopLeftBW = BWEdgeGridGeneration(TopLeft, 1, Grids.TopLeftStructure.nset, Grids.TopLeftStructure.IBPCount) ; 
TopRightBW = BWEdgeGridGeneration(TopRight, 1, Grids.TopRightStructure.nset, Grids.TopRightStructure.IBPCount) ;
BottomLeftBW = BWEdgeGridGeneration(BottomLeft, 1, Grids.BottomLeftStructure.nset, Grids.BottomLeftStructure.IBPCount) ; 
BottomRightBW = BWEdgeGridGeneration(BottomRight, 1, Grids.BottomRightStructure.nset, Grids.BottomRightStructure.IBPCount) ;

% Scan Left Structures
LeftCols = size(LeftGridX,2) ; 
n = 1 ;
nn = 1 ; 
for ScanColNum = 1:1:LeftCols

    % Top Left
    ScanColTop = TopLeftBW(:,ScanColNum) ; 
    [TopLeftLinePos, ~] = find(ScanColTop==0, Pixels2Count, 'Last') ;
    TopLeftLineAvg = mean(TopLeftLinePos(1:end-3)) ;
    check = isnan(TopLeftLineAvg);
    if check == 0
        TopLeftLine(n,:) = [ TopLeftLineAvg, ScanColNum ] ; % Right Line
        n = n + 1 ;
    end
     
    % Bottom Left
    ScanColBottom = BottomLeftBW(:, ScanColNum) ; 
    [BottomLeftLinePos, ~] = find(ScanColBottom==0, Pixels2Count,'First') ;
    BottomLeftLineAvg = mean(BottomLeftLinePos(1:end-3)) ; 
    check = isnan(BottomLeftLineAvg);
    if check == 0
        BottomLeftLine(nn,:) = [ BottomLeftLineAvg, ScanColNum ] ; % Right Line
        nn = nn + 1 ;
    end
     
end

BottomLeftLineAvg = mean(BottomLeftLine(:,1)) ; 
TopLeftLineAvg = mean(TopLeftLine(:,1)) ; 

% Scan Right Structures
RightCols = size(RightGridX,2) ; 
n = 1 ;
nn = 1 ; 
for ScanColNum = 1:1:RightCols

    % Top Left
    ScanColTop = TopRightBW(:,ScanColNum) ; 
    [TopRightLinePos, ~] = find(ScanColTop==0, Pixels2Count, 'Last') ;
    TopRightLineAvg = mean(TopRightLinePos(1:end-3)) ;
    check = isnan(TopRightLineAvg);
    if check == 0
        TopRightLine(n,:) = [ TopRightLineAvg, ScanColNum ] ; % Right Line
        n = n + 1 ;
    end
     
    % Bottom Left
    ScanColBottom = BottomRightBW(:, ScanColNum) ; 
    [BottomRightLinePos, ~] = find(ScanColBottom==0, Pixels2Count,'First') ;
    BottomRightLineAvg = mean(BottomRightLinePos(1:end-3)) ; 
    check = isnan(BottomRightLineAvg);
    if check == 0
        BottomRightLine(nn,:) = [ BottomRightLineAvg, ScanColNum ] ; % Right Line
        nn = nn + 1 ;
    end
     
end

BottomRightLineAvg = mean(BottomRightLine(:,1)) ; 
TopRightLineAvg = mean(TopRightLine(:,1)) ;

% Average Values With Reference to Grids.Structures.Coordinates Grid
BottomLineStructuresFrame = mean([ BottomRightLineAvg, BottomLeftLineAvg ] ) ; 
TopLineStructuresFrame = mean([TopRightLineAvg, TopLeftLineAvg]) ; 

% Export Values
BottomAdjustment = BottomLineStructuresFrame ; 
TopAdjustment = TopLineStructuresFrame ;

end