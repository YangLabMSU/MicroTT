function [NPD] = GridScan_BW_Compare_v0(InitialGridBW, NextGridBW)

[Rows, Cols] = find( InitialGridBW == 0 ) ;
NumRows = size(Rows,1) ;
Diff = zeros(NumRows,1) ;

for n = 1:1:size(Rows,1)

    Diff(n) = abs(InitialGridBW(Rows(n),Cols(n)) - NextGridBW(Rows(n),Cols(n))) ;

end

%Compare the absolute difference between previous and next frames
GD = sum(Diff) ;
NPD = GD / NumRows ;

end