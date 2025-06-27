function [GridImageBW] = HM_Binarize_Threshold_Adjust_v2(GridImage, TemplateImage, PixelRatioAdjust)

%TopTemplate = TemplateImage ;
TTP = numel(TemplateImage) ;
% TTW = numel(find(TemplateImage == 1));
TTB = numel(find(TemplateImage == 0)) ;
TTBPR = TTB / TTP ;
TTBPR = TTBPR - PixelRatioAdjust ; 

% imshow(GridImage) ;

%hist = histogram(GridImage) ;
avg = mean(GridImage,'all') ;
%med = median(GridImage, 'all') ;
%num = numel(GridImage) ;

InitialThresh = round(avg) ;

GridImageBW = GridImage ;
GridImageBW = (GridImage > InitialThresh == 1 ) ;
GridImageBW = (GridImage < InitialThresh == 0 ) ;

GIP = numel(GridImageBW) ;
GIW = numel(find(GridImageBW == 1));
GIB = numel(find(GridImageBW == 0)) ;
GIBPR = GIB / GIP ;

Iterations = 0 ; 
while GIBPR > TTBPR+0.01 || GIBPR < TTBPR-0.01 && Iterations < 200

    if GIBPR > TTBPR+0.01
        InitialThresh = InitialThresh - 1 ;
    elseif GIBPR < TTBPR-0.01
        InitialThresh = InitialThresh + 1 ;
    end

    GridImageBW = GridImage ;
    GridImageBW = (GridImage > InitialThresh == 1 ) ;
    GridImageBW = (GridImage < InitialThresh == 0 ) ;

    GIP = numel(GridImageBW) ;
    GIW = numel(find(GridImageBW == 1));
    GIB = numel(find(GridImageBW == 0)) ;
    GIBPR = GIB / GIP ;

    Iterations = Iterations + 1 ; 
end

%disp(Iterations) ; 
%imshow(GridImageBW) ; 

end