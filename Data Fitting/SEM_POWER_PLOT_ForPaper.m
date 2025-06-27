clear ; clc ; close all ;

% SEMData = [ 22 29 36 43 50 ; 2.5794 3.4535 4.8379 6.7046 10.2241]' ;

path = "K:\Yang Research\Two-Photon Polymerization\SEM\IP-S Data" ;
ColMats = ["IP-S_Sub_12-07-23_Col_1.mat", "IP-S_Sub_12-07-23_Col_2.mat", "IP-S_Sub_12-07-23_Col_3.mat", ...
    "IP-S_Sub_12-07-23_Col_4.mat", "IP-S_Sub_12-07-23_Col_5.mat", "IP-S_Sub_12-07-23_Col_6.mat", "IP-S_Sub_12-07-23_Col_7.mat"...
    "IP-S_Sub_12-07-23_Col_8.mat", "IP-S_Sub_12-07-23_Col_9.mat", "IP-S_Sub_12-07-23_Col_10.mat"]' ;

OutData = [] ;

for n = 1:size(ColMats,1)

    LoadPath = fullfile(path, ColMats(n)) ;
    load(LoadPath) ;

    if n == 1 || n == 2

        Power = 100 ;
        Area = SEM_Measurement_Data(2:end, 11) ;
        PowOut = zeros(size(Area,1),1) ;
        PowOut(:) = Power ;
        OutData = [ OutData ; PowOut, Area ] ;

    elseif n == 3 || n == 4

        Power = 86 ;
        Area = SEM_Measurement_Data(2:end, 11) ;
        PowOut = zeros(size(Area,1),1) ;
        PowOut(:) = Power ;
        OutData = [ OutData ; PowOut, Area ] ;

    elseif n == 5 || n == 6

        Power = 72 ;
        Area = SEM_Measurement_Data(2:end, 11) ;
        PowOut = zeros(size(Area,1),1) ;
        PowOut(:) = Power ;
        OutData = [ OutData ; PowOut, Area ] ;

    elseif n == 7 || n == 8

        Power = 58 ;
        Area = SEM_Measurement_Data(2:end, 11) ;
        PowOut = zeros(size(Area,1),1) ;
        PowOut(:) = Power ;
        OutData = [ OutData ; PowOut, Area ] ;

    elseif n == 9 || n == 10

        Power = 44 ;
        Area = SEM_Measurement_Data(2:end, 11) ;
        PowOut = zeros(size(Area,1),1) ;
        PowOut(:) = Power ;
        OutData = [ OutData ; PowOut, Area ] ;

    end

end

PlotFig = figure('units', 'centimeters', 'position', [15, 5, 6.6*3, 5.5*3]);

OutData(:,1) = double(OutData(:,1))*0.5 ; 
OutData = double(OutData) ; 
customBoxPlot_VectorMeasurements_ForPaper(OutData) ;

ylim([0, 12]) ;
yticks(linspace(0,12,7)) ; 
ylabel('SEM Area (um^2)');
% title('SEM Area', 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Power (mW)')
ax = gca;
set(gca, 'FontSize', 24);
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 2 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

% Plot Save
path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 4 - Writing Power Evaluation" ;
fileName = 'SEM Area Power Plot';
filename1 = fullfile(path,fileName);  % Set your desired file name
print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution


% fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 5 ]); hold on;
% plot(SEMData(:,1), SEMData(:,2), '+','linewidth', 3, 'MarkerSize', 10)  ;
% yticks(round(linspace(0,12,7))) ;
% ylim([0 12]) ;
% xticks([22 29 36 43 50]) ;
% xlim([20 52]) ;
% set(gca, 'FontSize', 14) ;



