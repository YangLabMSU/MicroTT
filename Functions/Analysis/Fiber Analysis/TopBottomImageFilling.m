function [BWImage, BPCount] = TopBottomImageFilling(BWImage) 

BWImage = imfill(imcomplement(BWImage)) ;
se = strel('disk', 5) ;
BWImage = imclose(BWImage, se) ;
BWImage = imcomplement(BWImage) ;
BPCount = size(find(BWImage==0),1) ;

end