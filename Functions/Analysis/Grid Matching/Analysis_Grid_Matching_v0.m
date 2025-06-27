function [ROI_Out, Data] = Analysis_Grid_Matching_v0(CurrentFrame, InitialGridBW, LastFrameBW, ROI, PixelRange)

% Evaluate Initial Pixel Difference
NPDI = GridScan_BW_Vertical_v0(InitialGridBW, CurrentFrame, ROI, 0) ; % Normalized Pixel Difference Initial

% Set Pixel Range to Check
PixStart = 1 ;
PixEnd = PixelRange.Vertical ;

Check = 0 ;
while Check == 0
    for PixDif = PixStart:1:PixEnd
        % Scan for Positive and Negative Displacements
        NPDAP(PixDif) = GridScan_BW_Vertical_v0(InitialGridBW, CurrentFrame, ROI, PixDif) ; % Normalized Pixel Difference Adjusted Positive
        NPDAN(PixDif) = GridScan_BW_Vertical_v0(InitialGridBW, CurrentFrame, ROI, -PixDif) ;% Normalized Pixel Difference Adjusted Negative
    end

    if min(NPDAP) < 0.1 || min(NPDAN) < 0.1 || NPDI < 0.1
        Check = 1 ;
    elseif PixDif < 25
        PixStart = PixEnd ;
        PixEnd = PixEnd + PixelRange.Vertical ;
    else
        Check = 1 ;
    end
end

% Find the minimum pixel difference, and adjust grids accordingly
[ Data.NormalizedPixelDifference, Data.DisplacementY ] = TPP_TensileTesting_GridScanDecision(NPDI,NPDAP,NPDAN) ;

% For the Case Where
if Data.DisplacementY == PixEnd || Data.DisplacementY == -PixEnd
if Data.DisplacementY == PixEnd
    for PixDif = PixEnd+1:1:PixEnd+5
        NPDAP(PixDif) = GridScan_BW_Vertical_v0(InitialGridBW, CurrentFrame, ROI, PixDif) ;               
    end
elseif Data.DisplacementY == -PixEnd
    for PixDif = PixEnd+1:1:PixEnd+5
        NPDAN(PixDif) = GridScan_BW_Vertical_v0(InitialGridBW, CurrentFrame, ROI, -PixDif) ;
    end
end

% Find the minimum pixel difference in the Y direction, save that pixel
[Data.NormalizedPixelDifference, Data.DisplacementY ] = TPP_TensileTesting_GridScanDecision(NPDI,NPDAP,NPDAN) ;
end

% Check small horizontal motion differences to ensure matching
for PixDif = 1:1:PixelRange.Horizontal
    % Scan for Positive and Negative Displacements
    NPDAPx(PixDif) = GridScan_BW_Horizontal_v0(InitialGridBW, CurrentFrame, ROI, PixDif) ;
    NPDANx(PixDif) = GridScan_BW_Horizontal_v0(InitialGridBW, CurrentFrame, ROI, -PixDif) ;
    
end

% Find the minimum pixel difference in the x direction, save that pixel
[~, Data.DisplacementX]  = TPP_TensileTesting_GridScanDecision(Data.NormalizedPixelDifference,NPDAPx,NPDANx) ;

% Generate New, Matched ROI using minimized grid check data
ROI_Out = ROI - [ Data.DisplacementY, Data.DisplacementX ; Data.DisplacementY, Data.DisplacementX ] ;

% Compare the New Frame with the Previous Grame
Data.LastFrameNormalizedPixelDifference = GridScan_BW_Vertical_v0(LastFrameBW, CurrentFrame, ROI_Out, 0) ;

% Generate BW Data -- Set-Up Grid from ROI
GYVN = ROI_Out(1,1):1:ROI_Out(2,1) ; % Grid Y Vector New
GXVN = ROI_Out(1,2):1:ROI_Out(2,2) ; % Grid X Vector New
Data.CurrentFrameBW = HM_Binarize_v0(CurrentFrame(GYVN,GXVN), InitialGridBW, 0) ;
Data.CurrentFrameBW = Binary_Grid_Clean_v32(Data.CurrentFrameBW, InitialGridBW, 200, "") ; 
%Data.CurrentFrameBW = Binary_Grid_Clean_v1(Data.CurrentFrameBW, 200, "") ; 

end
