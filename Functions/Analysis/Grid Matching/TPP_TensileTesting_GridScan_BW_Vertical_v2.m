function [NPD] = TPP_TensileTesting_GridScan_BW_Vertical_v2(NIG, GY, GX, PixDif, IGBW, nset)

[Rows, Cols] = find( IGBW == 0 ) ;
NumRows = size(Rows,1) ;
Diff = zeros(NumRows,1) ;

% Attain The Pixel Data of the next frame with previous position
GY = GY - PixDif  ;
NG = NIG( GY, GX ) ;
NG = HM_Binarize_By_Pixel_Count( NG, 1, nset, NumRows ) ; %Next Grid

for n = 1:1:NumRows

        Diff(n) = abs(IGBW(Rows(n),Cols(n)) - NG(Rows(n),Cols(n))) ;

end

%Compare the absolute difference between previous and next frames
GD = sum(Diff) ;
NPD = GD / NumRows ;

end