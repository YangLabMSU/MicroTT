function [] = AutomatedGridCheck_NoSave_Check(Grids, Image)

NewGridFig = figure() ;
NewGridFig.Position = [ 183,237,1585,656 ] ;

SPRows = 2 ;
SPCols = 6 ;

subplot(SPRows, SPCols, [ 1 7 ]) ; 
imshow(Image) ; 

subplot(SPRows, SPCols, 2) ;
imshow(Grids.TopLeftStructure.InitialBW);
title("Top Left") ;

subplot(SPRows, SPCols, [ 3 4 ]) ;
imshow(Grids.TopStructure.InitialBW);
title("Top Edge") ;

subplot(SPRows, SPCols, 5 ) ;
imshow(Grids.TopRightStructure.InitialBW);
title("Top Right") ;

subplot(SPRows, SPCols, 8) ;
imshow(Grids.BottomLeftStructure.InitialBW);
title("Bottom Left") ;

subplot(SPRows, SPCols, [ 9 10 ]) ;
imshow(Grids.BottomStructure.InitialBW);
title("Bottom Edge") ;

subplot(SPRows, SPCols, 11 ) ;
imshow(Grids.BottomRightStructure.InitialBW);
title("Bottom Right") ;

subplot(SPRows, SPCols, [ 6 12 ] ) ;
imshow(Grids.Fiber.InitialBW) ;
title("Fiber") ;

drawnow ;

% SavePath = Parameters.Folder ;
% figname = Parameters.FolderName ;
% dirname = fullfile(SavePath, "Automated Grid Generation Check") ;
% 
% if ~exist(dirname, 'dir')
%     mkdir(dirname)
% end
% 
% figsave = fullfile(dirname, figname);
% saveas(NewGridFig,figsave,'tiff');

pause(1) ;

%close(NewGridFig) ;

end