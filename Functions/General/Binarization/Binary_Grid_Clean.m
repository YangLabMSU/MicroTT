function [BWContourImage] = Binary_Grid_Clean(BWImage)
 
ContourBoundaries = bwboundaries(imcomplement(BWImage));
[~,MaxIndex] = sort(cellfun('length',ContourBoundaries)) ;
ContourBoundaries = ContourBoundaries(MaxIndex) ;

ContCount= size(ContourBoundaries,1) ; 

[rows, cols] = size(BWImage) ;
BWContourImage = ones(rows,cols) ;

for n = 1:1:ContCount

    Contour = ContourBoundaries{n} ; 
    ContSize = size(Contour, 1) ;

    if ContSize > 200 
        for i = 1:1:ContSize
            row = Contour(i,1) ;
            col = Contour(i,2) ;
            BWContourImage(row, col) = 0 ;
        end
    end

end

BWContourImage = imfill(imcomplement(BWContourImage), 'holes') ;
BWContourImage = imcomplement(BWContourImage) ;
%imshow(BWContourImage); 

end
