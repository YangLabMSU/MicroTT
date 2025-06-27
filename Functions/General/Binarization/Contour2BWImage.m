function [BWImage] = Contour2BWImage(contour, rows, cols)

BWImage = ones(rows,cols) ;

n = size(contour,1) ;
for i = 1:1:n
    row = contour(i,1) ;
    col = contour(i,2) ;

    BWImage(row, col) = 0 ;
end

end