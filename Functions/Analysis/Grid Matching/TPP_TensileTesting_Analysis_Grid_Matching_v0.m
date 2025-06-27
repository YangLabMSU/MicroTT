function [ROI_Out, Data] = TPP_TensileTesting_Analysis_Grid_Matching_v0(PixelRange, NextFrame, InitialFrame, LastFrame, ROI, IBPC, nset)

% Set-Up Grid from ROI
GridY = ROI(1,1):1:ROI(2,1) ;
GridX = ROI(1,2):1:ROI(2,2) ;
PC = size(GridY, 2) * size(GridX, 2) ;

% Set-Up Previous Frame for Difference
LastFrameBW = LastFrame(GridY, GridX) ;
LastFrameBW = HM_Binarize_By_Pixel_Count(LastFrameBW, 1, nset, IBPC) ; %Next Grid

% Evaluate Initial Pixel Difference
NPDI = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, 0, InitialFrame, nset) ;

% Set Pixel Range to Check
PixStart = 1 ;
PixEnd = PixelRange.Vertical ;

zzz = 0 ;
while zzz == 0
    for PixDif = PixStart:1:PixEnd

        % Scan for Positive and Negative Displacements
        NPDAP(PixDif) = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, PixDif, InitialFrame, nset) ;
        NPDAN(PixDif) = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, -PixDif, InitialFrame, nset) ;

    end

    if min(NPDAP) < 0.1 || min(NPDAN) < 0.1 || NPDI < 0.1

        zzz = 1 ;

    elseif PixDif < 25

        PixStart = PixEnd ;
        PixEnd = PixEnd + PixelRange.Vertical ;

    else

        zzz = 1 ;

    end

end

% Find the minimum pixel difference, and adjust grids accordingly
[ Data.NumberPixelDifference, Data.DisplacementY ] = TPP_TensileTesting_GridScanDecision(NPDI,NPDAP,NPDAN) ;

if Data.DisplacementY == PixEnd

    for PixDif = PixEnd+1:1:PixEnd+5
        % Scan for Positive and Negative Displacements
        NPDAP(PixDif) = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, PixDif, InitialFrame, nset) ;

    end
    
elseif Data.DisplacementY == -PixEnd

    for PixDif = PixEnd+1:1:PixEnd+5
        NPDAN(PixDif) = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, -PixDif, InitialFrame, nset) ;
    end

end

% Find the minimum pixel difference, and adjust grids accordingly
[ Data.NumberPixelDifference, Data.DisplacementY ] = TPP_TensileTesting_GridScanDecision(NPDI,NPDAP,NPDAN) ;
GridY = GridY - Data.DisplacementY ;


% Check small horizontal motion differences to ensure matching
for PixDif = 1:1:PixelRange.Horizontal

    % Scan for Positive and Negative Displacements
    NPDAPx(PixDif) = TPP_TensileTesting_GridScan_BW_Horizontal_v2(NextFrame, GridY, GridX, PixDif, InitialFrame, nset) ;
    NPDANx(PixDif) = TPP_TensileTesting_GridScan_BW_Horizontal_v2(NextFrame, GridY, GridX, -PixDif, InitialFrame, nset) ;

end

[~, Data.DisplacementX]  = TPP_TensileTesting_GridScanDecision(Data.NumberPixelDifference,NPDAPx,NPDANx) ;
GridX = GridX - Data.DisplacementX ;

% Generate New, Matched, ROI
ROI_Out = ROI - [ Data.DisplacementY, Data.DisplacementX ; Data.DisplacementY, Data.DisplacementX ] ;

% Compare the New Frame with the Previous Grame
% Find Number of Pixel Difference
Data.LastFrameNumberPixelDifference = TPP_TensileTesting_GridScan_BW_Vertical_v2(NextFrame, GridY, GridX, 0, LastFrameBW, nset) ;

end
