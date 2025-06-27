function [GridImageBW] = HM_Binarize_v1(GridImage, TemplateImage, PixelRatioAdjust)

% Previous Template and Contour Considerations? 
Check = 0 ; 
while Check == 0 
% Generate 
TPC = numel(TemplateImage) ; % Template Pixel Count
TBP = numel(find(TemplateImage == 0)) ; % Template Black Pixel Count 
TBPR = (TBP / TPC) - PixelRatioAdjust ; 

% Set Threshold
AvgGSVal = mean(GridImage,'all') ; % Average Grayscale Pixel Value (0-255)
InitialThresh = round(AvgGSVal) ; % Set Initial Grayscale Value Threshold to the Average

GridImageBW = ((GridImage < InitialThresh) == 0 ) ;

GIPC = numel(GridImageBW) ; % Grid Image Pixel Count
GIBC = numel(find(GridImageBW == 0)) ; % Grid Image Black Pixel Count
GIBPR = GIBC / GIPC ; % Grid Image Black Bixel Ratio

% Iterate the Threshold And Evaluate the Pixel Count
Iterations = 0 ; 
while GIBPR > TBPR+0.01 || GIBPR < TBPR-0.01 && Iterations < 200

    if GIBPR > TBPR+0.01
        InitialThresh = InitialThresh - 1 ;
    elseif GIBPR < TBPR-0.01
        InitialThresh = InitialThresh + 1 ;
    end

    % GridImageBW = GridImage ;
    % GridImageBW = ((GridImage > InitialThresh) == 1 ) ;
    % GridImageBW = ((GridImage < InitialThresh) == 0 ) ;

    GridImageBW = ((GridImage < InitialThresh) == 0 ) ;

    GIPC = numel(GridImageBW) ;
    GIBC = numel(find(GridImageBW == 0)) ;
    GIBPR = GIBC / GIPC ;

    Iterations = Iterations + 1 ; 
end

%disp(Iterations) ; 
%imshow(GridImageBW) ; 

ContourBoundaries = bwboundaries(imcomplement(GridImageBW));
if size(ContourBoundaries,1) < 5

    PixelRatioAdjust = PixelRatioAdjust - 0.005 ; 

else 

    Check = 1 ;

end

end