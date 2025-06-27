function [TopAdjustment, BottomAdjustment] = Edge_Adjustment_v0(TopGrid, BottomGrid, Grids, Pixels2Find)

% Set Pixel Evaluation Depth... how many found pixels to include in the average. Must ensure that the value is under the thickness of the edge
Pixels2Count = Pixels2Find + 1 ; 

% Split Top and Bottom Grids into their Corresponding Edge Grids -- first get the edge grid horizontal size
LXCL = Grids.BottomLeftStructure.Coordinates(2,2)-Grids.BottomLeftStructure.Coordinates(1,2) ; % Left X Coords Length 
RXCL = Grids.BottomRightStructure.Coordinates(2,2)-Grids.BottomRightStructure.Coordinates(1,2) ; % Right X Coords Length

LeftXCoords = 1:1:LXCL ; 
RightXCoords = (size(TopGrid,2) - RXCL):1:size(TopGrid,2) ; 

% Left Grids
TopLeftGridBW = TopGrid(:,LeftXCoords) ;
BottomLeftGridBW = BottomGrid(:,LeftXCoords) ; 

% Right Grids
TopRightGridBW = TopGrid(:,RightXCoords); 
BottomRightGridBW = BottomGrid(:,RightXCoords) ; 

% Scan Left Structures
LeftCols = size(LeftXCoords,2) ; 
n = 1 ;
nn = 1 ; 
for ScanColNum = 1:1:LeftCols

    % Top Left
    ScanColTop = TopLeftGridBW(:,ScanColNum) ; 
    [TopLeftLinePos, ~] = find(ScanColTop==0, Pixels2Count, 'Last') ;
    TopLeftLineAvg = mean(TopLeftLinePos(1:end-3)) ;
    check = isnan(TopLeftLineAvg);
    if check == 0
        TopLeftLine(n,:) = [ TopLeftLineAvg, ScanColNum ] ; % Right Line
        n = n + 1 ;
    end
     
    % Bottom Left
    ScanColBottom = BottomLeftGridBW(:, ScanColNum) ; 
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
RightCols = size(RightXCoords,2) ; 
n = 1 ;
nn = 1 ; 
for ScanColNum = 1:1:RightCols

    % Top Left
    ScanColTop = TopRightGridBW(:,ScanColNum) ; 
    [TopRightLinePos, ~] = find(ScanColTop==0, Pixels2Count, 'Last') ;
    TopRightLineAvg = mean(TopRightLinePos(1:end-3)) ;
    check = isnan(TopRightLineAvg);
    if check == 0
        TopRightLine(n,:) = [ TopRightLineAvg, ScanColNum ] ; % Right Line
        n = n + 1 ;
    end
     
    % Bottom Left
    ScanColBottom = BottomRightGridBW(:, ScanColNum) ; 
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