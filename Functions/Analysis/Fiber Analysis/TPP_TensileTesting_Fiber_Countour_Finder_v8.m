function [FiberContour, FiberContourPixelCount] = TPP_TensileTesting_Fiber_Countour_Finder_v8(InitialBW, LastFiberContourPixelCount)
% Invert the BW image
bw_image = imcomplement(InitialBW) ;

%Fill in the fiber to obtain a blacked out fiber image
[FiberContour, FiberContourPixelCount] = FiberImageFilling(InitialBW) ;



% % Perform contour detection
% contours = bwboundaries(bw_image);
% 
% for n = 1:1:length(contours)
% 
%     plot(contours{n,1}(:,2), contours{n,1}(:,1), 'LineWidth',2) ; hold on
% 
% end
% 
% % Put the contours in order from smallest to largest
% [~,MaxIndex] = sort(cellfun('length',contours)) ;
% MaxIndex = flip(MaxIndex) ;
% contours = contours(MaxIndex) ;
% 
% % Filter and process the detected contours by length
% min_contour_length = round(size(bw_image, 1) / 2 ); % Minimum length to consider as a valid contour
% 
% % Set up the "MaxContour", which will be combined and used to produce the new BW Image
% MaxContour = [] ;
% ContourCounter = 0 ;
% 
% % Check each contour to see if it has a long enough edge to be included
% for i = 1:1:length(contours)
% 
%     contour = contours{i};
% 
%     % Filter out short contours
%     if size(contour, 1) > min_contour_length
% 
%         MaxContour = [ MaxContour ; contour ];
%         ContourCounter = ContourCounter+1 ;
% 
%     end
% 
% end
% 
% % Using the initial image, generate a new image following the contours
[rows, cols] = size(bw_image) ;
% FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
% 
% %Fill in the fiber to obtain a blacked out fiber image
% [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;

% Check the Final Contour to ensure there are not floater
ContourCheck = length(bwboundaries(imcomplement(FiberContour))) ;

if ContourCheck > 1

    ContoursCheck2 = bwboundaries(imcomplement(FiberContour));
    [~,MaxIndex2] = sort(cellfun('length',ContoursCheck2)) ;
    MaxIndex2 = flip(MaxIndex2) ;
    ContoursCheck2 = ContoursCheck2(MaxIndex2) ;
    MaxContour = ContoursCheck2{1} ;
    FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
    [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;

end



% % Check the Final Contour to ensure there are not floater
% ContourCheck = length(bwboundaries(imcomplement(FiberContour))) ;
% 
% % If there are multiple countours, one is a floater, choose the largest
% % contour to become the single fiber image
% if ContourCheck > 1
% 
%     ContoursCheck2 = bwboundaries(imcomplement(FiberContour));
%     [~,MaxIndex2] = sort(cellfun('length',ContoursCheck2)) ;
%     MaxIndex2 = flip(MaxIndex2) ;
%     ContoursCheck2 = ContoursCheck2(MaxIndex2) ;
%     MaxContour = ContoursCheck2{1} ;
%     FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
%     [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;
% 
% end
% 
% % Now, there is only a single contour, Evaluate the pixel count relative to
% % previous, evaluating for significant deviation. Take it as a ratio of the
% % total image
% 
% PCRThresh = 0.015 ; % Pixel Count Ratio Threshold
% z = 0 ;
% i = 1 ;
% while z == 0
%     % Check to see if Significant Value is exceeded
%     SigValCheck(i) = ( FiberContourPixelCount - LastFiberContourPixelCount ) / numel(bw_image) ;
% 
%     % If the new fiber count exceeds the older fiber count, reduce the number of pixels
%     if SigValCheck(i) > PCRThresh
% 
%         % If there will be more than 1 contours included, rebuild MaxContour
%         if ContourCounter > 2
% 
%             ContourCounter = ContourCounter-1 ;
%             MaxContour = [] ;
%             for n = 1:1:ContourCounter
%                 contour = contours{n} ;
%                 MaxContour = [ MaxContour ; contour] ;
%             end
%             FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
%             [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;
% 
%             % if there will be only a single contour include, take the largest
%             % original contour.
%         elseif ContourCounter == 2
% 
%             ContourCounter = ContourCounter-1 ;
%             MaxContour = contours{ContourCounter} ;
%             FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
%             [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;
% 
%             % If only a single contour was included, then pixel reduction is not
%             % possible
%         elseif ContourCounter < 2
% 
%             % Do Nothing, it is what it is, Get out of the loop
%             z = 1 ;
% 
%         end
% 
%         % If the new pixel count is less than the old fiber count, increase the number of pixels
%     elseif SigValCheck(i) < -PCRThresh
% 
%         if length(contours) > ContourCounter
% 
%             ContourCounter = ContourCounter + 1 ; % Increase Contour Count by 1
%             MaxContour = [ MaxContour ; contours{ContourCounter}] ; % Add the additionaly Contour to the Max Countour
%             FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
%             [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;
% 
%         elseif length(contours) == ContourCounter
% 
%             % Do Nothing, you have included all found original contours
%             % it is what it is, Get out of the loop
%             z = 1 ;
% 
%         end
% 
%     elseif SigValCheck(i) > -PCRThresh && SigValCheck(i) < PCRThresh
% 
%         % No Significant Deviation, get out of the loop
%         z = 1 ;
% 
%     end
% 
%     % if there have been multiple iterations
%     if i > 2
% 
%         Current = SigValCheck(i) ;
%         Last = SigValCheck(i-1) ;
%         Back = SigValCheck(i-2) ;
% 
%         if Current == Back
% 
%             if Current < Last
%                 z = 1 ;
%             end
% 
%         elseif Current > 0 && Last < 0 && Back > 0
% 
%             if Current < Last
%                 z = 1 ;
%             end
% 
%         elseif Current < 0 && Last > 0 && Back < 0
% 
%             if Current < Last
%                 z = 1 ;
%             end
% 
%         end
% 
%     end
% 
%     % Check the Final Contour to ensure there are no floaters
%     ContourCheck = length(bwboundaries(imcomplement(FiberContour))) ;
%     if ContourCheck > 1
% 
%         ContoursCheck2 = bwboundaries(imcomplement(FiberContour));
%         [~,MaxIndex2] = sort(cellfun('length',ContoursCheck2)) ;
%         MaxIndex2 = flip(MaxIndex2) ; 
%         ContoursCheck2 = ContoursCheck2(MaxIndex2) ;
%         MaxContour = ContoursCheck2{1} ;
%         FiberContour = Contour2BWImage(MaxContour, rows, cols) ;
%         [FiberContour, FiberContourPixelCount] = FiberImageFilling(FiberContour) ;
% 
%     end
% 
%     i = i + 1 ;
% 
% end

end

