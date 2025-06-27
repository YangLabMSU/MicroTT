function [] = AutomatedGridCheck_NoSave(Grids, Parameters)

NewGridFig = figure() ;
NewGridFig.Position = [ 183,237,1585,656 ] ;

SPRows = 2 ;
SPCols = 5 ;

subplot(SPRows, SPCols, 1) ;
imshow(Grids.TopLeftStructure.InitialBW);
title("Top Left") ;

subplot(SPRows, SPCols, [ 2 3 ]) ;
imshow(Grids.TopStructure.InitialBW);
title("Top Edge") ;

subplot(SPRows, SPCols, 4 ) ;
imshow(Grids.TopRightStructure.InitialBW);
title("Top Right") ;

subplot(SPRows, SPCols, 6) ;
imshow(Grids.BottomLeftStructure.InitialBW);
title("Bottom Left") ;

subplot(SPRows, SPCols, [ 7 8 ]) ;
imshow(Grids.BottomStructure.InitialBW);
title("Bottom Edge") ;

subplot(SPRows, SPCols, 9 ) ;
imshow(Grids.BottomRightStructure.InitialBW);
title("Bottom Right") ;

subplot(SPRows, SPCols, [ 5 10 ] ) ;
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