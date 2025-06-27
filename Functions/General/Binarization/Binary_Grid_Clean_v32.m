function [BWContourImage2] = Binary_Grid_Clean_v32(BWImage, InitialGridBW, ContSizeThresh, FillStyle)

NPDInitial = GridScan_BW_Compare_v0(InitialGridBW, BWImage) ; 

ContourBoundaries = bwboundaries(imcomplement(BWImage));
[~,MaxIndex] = sort(cellfun('length',ContourBoundaries)) ;
ContourBoundaries = ContourBoundaries(MaxIndex) ;

ContCount= size(ContourBoundaries,1) ; 

[rows, cols] = size(BWImage) ;
BWContourImage = ones(rows,cols) ;

for n = 1:1:ContCount

    Contour = ContourBoundaries{n} ; 
    ContSize = size(Contour, 1) ;

    if ContSize > ContSizeThresh 
        for i = 1:1:ContSize
            row = Contour(i,1) ;
            col = Contour(i,2) ;
            BWContourImage(row, col) = 0 ;
        end
    end

end

if FillStyle == "holes" || FillStyle == "Holes"
    BWContourImage = imfill(imcomplement(BWContourImage), 'holes') ;
else
    BWContourImage = imfill(imcomplement(BWContourImage)) ;
end

BWContourImage = imcomplement(BWContourImage) ;

[BWContourImage2, ~] = GridBuildingByContours(BWContourImage, 1) ; 
NPDComp = GridScan_BW_Compare_v0(InitialGridBW, BWContourImage2) ;
NPDCompDiff = abs(NPDInitial - NPDComp)  ;
NPDCompDiffCheck(1) = NPDCompDiff ; 
i = 1 ; 
while NPDCompDiff > 0.05 
    
    i = i + 1 ; 
    [BWContourImage2, ExitFlag] = GridBuildingByContours(BWContourImage, i) ; 
    NPDComp = GridScan_BW_Compare_v0(InitialGridBW, BWContourImage2) ;
    NPDCompDiff = abs(NPDInitial - NPDComp)  ;
    NPDCompDiffCheck(i) = NPDCompDiff ; 

    if ExitFlag == "Exit"
        
        [~,NPDIdx] = min(NPDCompDiffCheck) ; 
        [BWContourImage2, ~] = GridBuildingByContours(BWContourImage, NPDIdx) ; 
        NPDCompDiff = 0 ; 

    end
end

end
