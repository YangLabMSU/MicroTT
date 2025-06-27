function [Grids] = Auto_SetWBPixelRatio_v0(Grids, AutoTemplate)
%%%%%%%%%%%%% Initialize the Grids %%%%%%%%%%%%%

% Load in Initial Grids
TGI = Grids.TopStructure.Initial ; % Top Grid Initial
BGI = Grids.BottomStructure.Initial ; % Bottom Grid Initial
FGI = Grids.Fiber.Initial ; % Fiber Grid Initial
TRGI = Grids.TopRightStructure.Initial ; % Top Right Grid Initial
TLGI = Grids.TopLeftStructure.Initial ; % Top Left Grid Initial
BLGI = Grids.BottomLeftStructure.Initial; % Bottom Left Grid Initial
BRGI = Grids.BottomRightStructure.Initial ; % Bottom Right Grid Initial

%%%%%%%%%%%%% Initialize the Template %%%%%%%%%%%%%

% Load in BW Images from Automated Template 
TemplateBWImages = AutoTemplate.BWImages ;

% Template Grid Size
TopStructureSize = numel(TemplateBWImages.TopStructure.InitialBW) ;
BottomStructureSize = numel(TemplateBWImages.BottomStructure.InitialBW) ;
FiberSize = numel(TemplateBWImages.Fiber.InitialBW) ;
TopRightSize = numel(TemplateBWImages.TopRightStructure.InitialBW) ;
TopLeftSize = numel(TemplateBWImages.TopLeftStructure.InitialBW) ;
BottomRightSize = numel(TemplateBWImages.BottomRightStructure.InitialBW) ;
BottomLeftSize = numel(TemplateBWImages.BottomLeftStructure.InitialBW) ;

% Black Pixel Ratio From Template
TopStructurePR = TemplateBWImages.TopStructure.IBPCount / TopStructureSize ;
BottomStructurePR = TemplateBWImages.BottomStructure.IBPCount / BottomStructureSize ;

FiberPR = TemplateBWImages.Fiber.IBPCount / FiberSize ;
FiberContourPR = TemplateBWImages.Fiber.ContourIBPCount / FiberSize ; 

TopRightPR = TemplateBWImages.TopRightStructure.IBPCount / TopRightSize ;
TopLeftPR = TemplateBWImages.TopLeftStructure.IBPCount / TopLeftSize ;
BottomLeftPR = TemplateBWImages.BottomLeftStructure.IBPCount / BottomLeftSize ;
BottomRightPR = TemplateBWImages.BottomRightStructure.IBPCount / BottomRightSize ;

%%%%%%%%%%%%% BW Grid Generation %%%%%%%%%%%%%

% Estimation of Initial Black Pixel Count (IBPC)
TopStructureIBPCount = round(numel(TGI) * TopStructurePR) ; 
BottomStructureIBPCount = round(numel(BGI) * BottomStructurePR) ;
FiberIBPCount = round(numel(FGI) * FiberPR) ;
FiberContourIBPCount = round(numel(FGI) * FiberContourPR) ; 
TopRightIBPCount = round(numel(TRGI) * TopRightPR) ;
TopLeftIBPCount = round(numel(TLGI) * TopLeftPR) ;
BottomLefIBPCount = round(numel(BLGI) * BottomLeftPR) ;
BottomRightIBPCount = round(numel(BRGI) * BottomRightPR) ;

% Generate Initial BW Grids for All Components

% Top and Bottom
[ Grids.BottomStructure.InitialBW, Grids.BottomStructure.IBPCount, Grids.BottomStructure.nset ] =  HM_Binarize_By_Elimination_Bottom(BGI, 1, TemplateBWImages.BottomStructure.nset, BottomStructureIBPCount) ;
[ Grids.TopStructure.InitialBW, Grids.TopStructure.IBPCount, Grids.TopStructure.nset ] = HM_Binarize_Top(TGI, 1, TemplateBWImages.TopStructure.nset, TopStructureIBPCount) ;

% Fiber
Grids.Fiber.IBPCount = FiberIBPCount ; 
[ Grids.Fiber.InitialBW, Grids.Fiber.nset ] = HM_Binarize_By_Pixel_Count_v2(FGI, 1, TemplateBWImages.Fiber.nset, FiberIBPCount) ;
[ Grids.Fiber.InitialBW, Grids.Fiber.ContourIBPCount ] = TPP_TensileTesting_Fiber_Countour_Finder_v6(Grids.Fiber.InitialBW, FiberContourIBPCount) ;

% Edges
[ Grids.TopRightStructure.InitialBW, Grids.TopRightStructure.nset ] = HM_Binarize_By_Pixel_Count_v2(TRGI, 1, TemplateBWImages.TopRightStructure.nset, TopRightIBPCount) ;
[ Grids.TopRightStructure.InitialBW, Grids.TopRightStructure.IBPCount ] = TPP_TensileTesting_Edge_Countour_Finder_v1(Grids.TopRightStructure.InitialBW) ;

[ Grids.TopLeftStructure.InitialBW, Grids.TopLeftStructure.nset ] = HM_Binarize_By_Pixel_Count_v2(TLGI, 1, TemplateBWImages.TopLeftStructure.nset, TopLeftIBPCount) ;
[ Grids.TopLeftStructure.InitialBW, Grids.TopLeftStructure.IBPCount ]  = TPP_TensileTesting_Edge_Countour_Finder_v1(Grids.TopLeftStructure.InitialBW) ;

[ Grids.BottomLeftStructure.InitialBW, Grids.BottomLeftStructure.nset ] = HM_Binarize_By_Pixel_Count_v2(BLGI, 1, TemplateBWImages.BottomLeftStructure.nset, BottomLefIBPCount) ;
[ Grids.BottomLeftStructure.InitialBW, Grids.BottomLeftStructure.IBPCount ] = TPP_TensileTesting_Edge_Countour_Finder_v1(Grids.BottomLeftStructure.InitialBW) ;

[ Grids.BottomRightStructure.InitialBW, Grids.BottomRightStructure.nset ] = HM_Binarize_By_Pixel_Count_v2(BRGI, 1, TemplateBWImages.BottomRightStructure.nset, BottomRightIBPCount) ;
[ Grids.BottomRightStructure.InitialBW, Grids.BottomRightStructure.IBPCount ] = TPP_TensileTesting_Edge_Countour_Finder_v1(Grids.BottomRightStructure.InitialBW) ; 

% White to Black Pixel Ratio
Grids.TopStructure.BPR = TopStructurePR ;
Grids.BottomStructure.BPR = BottomStructurePR ;
Grids.Fiber.BPR= FiberPR ;
Grids.TopRightStructure.BPR = TopRightPR ;
Grids.TopLeftStructure.BPR = TopLeftPR ;
Grids.BottomRightStructure.BPR = BottomRightPR ;
Grids.BottomLeftStructure.BPR = BottomLeftPR ;

end