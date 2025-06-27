function [BWContourImage2] = Binary_Grid_Clean_v2(BWImage, ContourSizeThresh, FillStyle)

ContourBoundaries = bwboundaries(imcomplement(BWImage));
[~,MaxIndex] = sort(cellfun('length',ContourBoundaries)) ;
ContourBoundaries = ContourBoundaries(MaxIndex) ;

ContCount= size(ContourBoundaries,1) ;

[rows, cols] = size(BWImage) ;
BWContourImage = ones(rows,cols) ;

for n = 1:1:ContCount

    Contour = ContourBoundaries{n} ;
    ContSize = size(Contour, 1) ;

    if ContSize > ContourSizeThresh
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

% Take the Larges Boundary
ContourBoundaries2 = bwboundaries(imcomplement(BWContourImage));
[~,MaxIndex] = sort(cellfun('length',ContourBoundaries2)) ;
ContourBoundaries2 = ContourBoundaries2(MaxIndex) ;

MaxContour = ContourBoundaries2{end} ;
[rows, cols] = size(BWImage) ;
BWContourImage2 = ones(rows,cols) ;
n = size(MaxContour,1) ;
for i = 1:1:n
    row = MaxContour(i,1) ;
    col = MaxContour(i,2) ;
    BWContourImage2(row, col) = 0 ;
end

if FillStyle == "holes" || FillStyle == "Holes"
    BWContourImage2 = imfill(imcomplement(BWContourImage2), 'holes') ;
else
    BWContourImage2 = imfill(imcomplement(BWContourImage2)) ;
end

BWContourImage2 = imcomplement(BWContourImage2) ;

%imshow(BWContourImage);

end
