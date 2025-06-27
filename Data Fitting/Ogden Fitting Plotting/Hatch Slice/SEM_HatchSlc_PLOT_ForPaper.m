clear ; clc ; close all ;

% SEMData = [ 22 29 36 43 50 ; 2.5794 3.4535 4.8379 6.7046 10.2241]' ;

path = "K:\Yang Research\Two-Photon Polymerization\SEM\7-8-24\IP-S - 6-05-24" ;
ColMats = "Fiber Area Measurements.mat" ;

LoadPath = fullfile(path, ColMats) ;
load(LoadPath) ;
OutData = [] ; 
OutData1 = [] ; 
OutData2 = [] ; 
OutData3 = [] ; 

BasePower = 60 ; 
BaseSpeed = 50 ; 

for n = 2:size(FiberAreaMeasuremnt,1)

ArrayPos = FiberAreaMeasuremnt(n,1) ; 
if size(char(ArrayPos),2) == 2
    ArrayPos = char(ArrayPos) ; 
    Column = ArrayPos(2) ; 
    Column = double(string(Column)) ; 
else 
    Column = 10 ; 
end


    if Column == 5 || Column == 6

        Slice = 0.5 ;
        Hatch = 0.5 ; 
        Area = FiberAreaMeasuremnt(n, 4) ;
        HatchSlc = zeros(size(Area,1),1) ;
        HatchSlcOut(:) = [ Slice Hatch ] ; % Hatch + " x " + Slice ;
        HSOut = Slice + " x " + Hatch ;
        OutData = [ OutData ; HSOut, Area ] ; 
        OutData1 = [ OutData1 ; HatchSlcOut, Area ] ;

    elseif Column == 8

        Slice = 0.5 ;
        Hatch = 0.25 ; 
        Area = FiberAreaMeasuremnt(n, 4) ;
        HatchSlc = zeros(size(Area,1),1) ;
        HatchSlcOut(:) = [ Slice Hatch ] ; % Hatch + " x " + Slice ;
        HSOut = Slice + " x " + Hatch ;
        OutData = [ OutData ; HSOut, Area ] ; 
        OutData2 = [ OutData2 ; HatchSlcOut, Area ] ;

    elseif Column == 9

        Slice = 0.25 ;
        Hatch = 0.25 ; 
        Area = FiberAreaMeasuremnt(n, 4) ;
        HatchSlc = zeros(size(Area,1),1) ;
        HatchSlcOut(:) = [ Slice Hatch ] ; % Hatch + " x " + Slice ;
        HSOut = Slice + " x " + Hatch ;
        OutData = [ OutData ; HSOut, Area ] ; 
        OutData3 = [ OutData3 ; HatchSlcOut, Area ] ;

    end

end

OutData1 = OutData(~ismissing(OutData1(:,3)),:) ; 
OutData2 = OutData(~ismissing(OutData2(:,3)),:) ; 
OutData3 = OutData(~ismissing(OutData3(:,3)),:) ; 

OutData = OutData(~ismissing(OutData(:,2)),:) ; 

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;
customBoxPlot_VectorMeasurements_HATSLC(OutData) ;

% 
ylim([5, 40]) ;
yticks(linspace(5,35,5)) ;
ylabel('SEM Area (um^2)');
xlabel('Slice x Hatch (\mum)'); 
ax = gca;
set(gca, 'FontSize', 15);
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

% 
% % Plot Save
% path = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Hatch Slice" ;
% fileName = 'SEM Area Hat Slc Plot';
% filename1 = fullfile(path,fileName);  % Set your desired file name
% print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution


% fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 5 ]); hold on;
% plot(SEMData(:,1), SEMData(:,2), '+','linewidth', 3, 'MarkerSize', 10)  ;
% yticks(round(linspace(0,12,7))) ;
% ylim([0 12]) ;
% xticks([22 29 36 43 50]) ;
% xlim([20 52]) ;
% set(gca, 'FontSize', 14) ;



