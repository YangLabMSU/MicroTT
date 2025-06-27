function [BWContourImage] = Binary_Grid_Clean_v1(BWImage, ContSizeThresh, FillStyle)
 
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
%imshow(BWContourImage); 

end
