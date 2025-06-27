clear ; clc ; close all ;

% SEMData = [ 22 29 36 43 50 ; 2.5794 3.4535 4.8379 6.7046 10.2241]' ;

path = "K:\Yang Research\Two-Photon Polymerization\SEM\7-8-24\IP-S Write Speed Variation" ;
ColMats = "Fiber Area Measurements.mat" ;

LoadPath = fullfile(path, ColMats) ;
load(LoadPath) ;
OutData = [] ; 

for n = 2:size(FiberAreaMeasuremnt,1)

ArrayPos = FiberAreaMeasuremnt(n,1) ; 
if size(char(ArrayPos),2) == 2
    ArrayPos = char(ArrayPos) ; 
    Column = ArrayPos(2) ; 
    Column = double(string(Column)) ; 
else 
    Column = 10 ; 
end

    if Column == 1

        Speed = 80 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 2

        Speed = 72 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 3

        Speed = 64 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 4

        Speed = 56 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 5

        Speed = 48 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 6

        Speed = 40 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 7

        Speed = 32 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 8

        Speed = 24 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 9

        Speed = 16 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    elseif Column == 10

        Speed = 8 ;
        Area = FiberAreaMeasuremnt(n, 4) ;
        SpeedOut = zeros(size(Area,1),1) ;
        SpeedOut(:) = Speed ;
        OutData = [ OutData ; SpeedOut, Area ] ;

    end

end

PlotFig = figure('units', 'centimeters', 'position', [15, 5, 6.6*3, 5.5*3]);

OutData = double(OutData) ;
customBoxPlot_VectorMeasurements_ForPaper(OutData) ;

ylim([5, 15]) ;
yticks(linspace(5,15,6)) ;
ylabel('SEM Area (um^2)');
% title('SEM Area', 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Write Speed (mm/s)')
ax = gca;
set(gca, 'FontSize', 24);
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 2 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

% % Plot Save
% path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 5 - Writing Speed Evaluation" ;
% fileName = 'SEM Area Power Plot';
% filename1 = fullfile(path,fileName);  % Set your desired file name
% print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution


% fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 5 ]); hold on;
% plot(SEMData(:,1), SEMData(:,2), '+','linewidth', 3, 'MarkerSize', 10)  ;
% yticks(round(linspace(0,12,7))) ;
% ylim([0 12]) ;
% xticks([22 29 36 43 50]) ;
% xlim([20 52]) ;
% set(gca, 'FontSize', 14) ;



