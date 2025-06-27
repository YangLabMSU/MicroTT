function [BWContourImage, ExitFlag] = GridBuildingByContours(BWImage, NumContours) 

ExitFlag = "" ; 
% Take the Larges Boundary
ContourBoundaries = bwboundaries(imcomplement(BWImage));
[~,MaxIndex] = sort(cellfun('length',ContourBoundaries)) ;
ContourBoundaries = ContourBoundaries(MaxIndex) ;

if NumContours > size(ContourBoundaries,1)
    NumContours = size(ContourBoundaries,1) ; 
    ExitFlag = "Exit" ; 
end

for nn = 1:1:NumContours

    if nn == 1 

        MaxContour = ContourBoundaries{end} ;

    else

        MaxContour = [ MaxContour ; ContourBoundaries{end-(nn-1)}] ; 

    end

end

[rows, cols] = size(BWImage) ;
BWContourImage = ones(rows,cols) ;
n = size(MaxContour,1) ;
for i = 1:1:n
    row = MaxContour(i,1) ;
    col = MaxContour(i,2) ;
    BWContourImage(row, col) = 0 ;
end

BWContourImage = imfill(imcomplement(BWContourImage)) ;
BWContourImage = imcomplement(BWContourImage) ;

end
