function [Grid] = Auto_Grid_and_Coordinate_Generation_v0(Video, Parameters, AutoTemplate)

% Load in Images from the Template
Images = AutoTemplate.Images ;

% Load Target Frame
InitialFrame = read(Video, 1) ;

if size(find(InitialFrame==0),1) == numel(InitialFrame)
    % Load Target Frame
    InitialFrame = read(Video, 25) ;
end

% Increase Resolution
[ Rows, ~ ] = size(InitialFrame) ;
TargetFrame_Enhanced = im2gray(imresize(InitialFrame, [Rows*Parameters.ResolutionMultiplier, NaN]));

% Initialize Targate Templates
TopTargetTemplate = Images.TopStructure.Initial ;
BottomTargetTemplate = Images.BottomStructure.Initial ;
BottomLeftTargetTemplate = Images.BottomLeftStructure.Initial ;
BottomRightTargetTemplate = Images.BottomRightStructure.Initial ;

% Conduct Correlations to Find Grid Positions
TopCorrelation = normxcorr2(TopTargetTemplate,TargetFrame_Enhanced);
BottomCorrelation = normxcorr2(BottomTargetTemplate, TargetFrame_Enhanced) ;
BottomLeftCorrelation = normxcorr2(BottomLeftTargetTemplate, TargetFrame_Enhanced) ;
BottomRightCorrelation = normxcorr2(BottomRightTargetTemplate, TargetFrame_Enhanced) ;

% Top Structure
[TopStructureYMax,TopStructureXMax] = find(TopCorrelation==max(TopCorrelation(:)));
TopStructureYMin = TopStructureYMax-size(TopTargetTemplate,1) ;
TopStructureXMin = TopStructureXMax-size(TopTargetTemplate,2) ;

% Bottom Structure
[BottomStructureYMax,~] = find(BottomCorrelation==max(BottomCorrelation(:)));
BottomStructureYMin = BottomStructureYMax-size(BottomTargetTemplate,1) ;

% Bottom Left Structure
[~,BottomLeftXMax] = find(BottomLeftCorrelation==max(BottomLeftCorrelation(:)));

% Bottom Right Structure
[~,BottomRightXMax] = find(BottomRightCorrelation==max(BottomRightCorrelation(:)));
BottomRightXMin = BottomRightXMax-size(BottomRightTargetTemplate,2) ;

% Use the Coordinates to Construct the New Grids
% Coordinate Organization
XMin = TopStructureXMin ;
XMax = TopStructureXMax ;

TopYMin = TopStructureYMin ;
TopYMax = TopStructureYMax ;

BottomYMin = BottomStructureYMin ;
BottomYMax = BottomStructureYMax ;

LeftXMax = BottomLeftXMax ;
RightXMin = BottomRightXMin ;
 
% Initial Image and Coordinate Generation
Grid.TopStructure.Coordinates = [ TopYMin , XMin ;  TopYMax, XMax ] ;
Grid.TopStructure.Initial = TargetFrame_Enhanced(Grid.TopStructure.Coordinates(1,1):1:Grid.TopStructure.Coordinates(2,1), Grid.TopStructure.Coordinates(1,2):1:Grid.TopStructure.Coordinates(2,2)) ;

Grid.BottomStructure.Coordinates = [ BottomYMin, XMin ; BottomYMax, XMax ] ;
Grid.BottomStructure.Initial = TargetFrame_Enhanced(Grid.BottomStructure.Coordinates(1,1):1:Grid.BottomStructure.Coordinates(2,1), Grid.BottomStructure.Coordinates(1,2):1:Grid.BottomStructure.Coordinates(2,2)) ;

Grid.Fiber.Coordinates = [ TopYMax,  LeftXMax ; BottomYMin, RightXMin ] ;
Grid.Fiber.Initial = TargetFrame_Enhanced(Grid.Fiber.Coordinates(1,1):1:Grid.Fiber.Coordinates(2,1), Grid.Fiber.Coordinates(1,2):1:Grid.Fiber.Coordinates(2,2)) ;

Grid.TopLeftStructure.Coordinates = [ TopYMin , XMin ;  TopYMax, LeftXMax ] ;
Grid.TopLeftStructure.Initial = TargetFrame_Enhanced(Grid.TopLeftStructure.Coordinates(1,1):1:Grid.TopLeftStructure.Coordinates(2,1), Grid.TopLeftStructure.Coordinates(1,2):1:Grid.TopLeftStructure.Coordinates(2,2)) ;

Grid.TopRightStructure.Coordinates = [ TopYMin , RightXMin ;  TopYMax, XMax] ;
Grid.TopRightStructure.Initial = TargetFrame_Enhanced(Grid.TopRightStructure.Coordinates(1,1):1:Grid.TopRightStructure.Coordinates(2,1), Grid.TopRightStructure.Coordinates(1,2):1:Grid.TopRightStructure.Coordinates(2,2)) ;

Grid.BottomLeftStructure.Coordinates = [ BottomYMin , XMin ;  BottomYMax, LeftXMax  ] ;
Grid.BottomLeftStructure.Initial = TargetFrame_Enhanced(Grid.BottomLeftStructure.Coordinates(1,1):1:Grid.BottomLeftStructure.Coordinates(2,1), Grid.BottomLeftStructure.Coordinates(1,2):1:Grid.BottomLeftStructure.Coordinates(2,2)) ;

Grid.BottomRightStructure.Coordinates = [ BottomYMin , RightXMin ; BottomYMax, XMax ] ;
Grid.BottomRightStructure.Initial = TargetFrame_Enhanced(Grid.BottomRightStructure.Coordinates(1,1):1:Grid.BottomRightStructure.Coordinates(2,1), Grid.BottomRightStructure.Coordinates(1,2):1:Grid.BottomRightStructure.Coordinates(2,2)) ;

end