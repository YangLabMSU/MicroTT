clear ; clc ; close ;

% Plotting for Figure 3 of Next Paper
% Goal is to Clearly Plot the Stress Strain Data as an example

% Load All Data 
DataPath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Data - v3 - Analyzed\Substrate 12-07-23_TD 1-24-24\2\Processed Data.mat" ;
load(DataPath) ;

% Split into Seperate Sections
StrIdx = ProcessedData.StretchIdx(1):1:ProcessedData.StretchIdx(end) ; 
HoldIdx = ProcessedData.HoldIdx(1):1:ProcessedData.HoldIdx(2) ; 
ReturnIdx = ProcessedData.HoldIdx(2):1:size(ProcessedData.Stress) ; 

ProcessedData.Stress = ProcessedData.Stress - ProcessedData.Stress(1) ; 
ProcessedData.PlateStrain = ProcessedData.PlateStrain - ProcessedData.PlateStrain(1) ; 

StretchStress = ProcessedData.Stress(StrIdx) ;
StretchStrain = ProcessedData.PlateStrain(StrIdx) ; 
HoldStress = ProcessedData.Stress(HoldIdx) ;
HoldStrain = ProcessedData.PlateStrain(HoldIdx) ; 
ReturnStress = ProcessedData.Stress(ReturnIdx) ;
ReturnStrain = ProcessedData.PlateStrain(ReturnIdx) ; 

ReturnFiberStrain = ProcessedData.FiberStrain(ReturnIdx) ;
Diff = ReturnFiberStrain(1) - ReturnStrain(1) ; 
ReturnFiberStrain = ReturnFiberStrain - Diff ; 

% load data
load('Stretch Experiment Data Fit - v2.mat') ;
n = 30 ;

Stress = StretchExperimentData{n,2} ;
Strain = StretchExperimentData{n,3} ;

% Load In Critical Data
CriticalPts = StretchExperimentData{n,4} ;

YieldIdx = CriticalPts(1) ;
EqIdx = CriticalPts(2) ;
FPIdx = CriticalPts(3) ;

% Assign Fitting Data
YieldStress = Stress(YieldIdx) ;
YieldStrain = Strain(YieldIdx) ;
EqStress = Stress(EqIdx) ;
EqStrain = Strain(EqIdx) ;
FPStress = Stress(FPIdx) ;
FPStrain = Strain(FPIdx) ;

% Fitting Values
FittingValues = StretchExperimentData{n,5} ;
E1 = FittingValues(1) ;
E2 = FittingValues(2) ;
Lam1 = FittingValues(3) ;
E3 = FittingValues(4) ;
Lam2 = FittingValues(5) ;

% Generate Linear Curve
LinStrain = Strain(1:YieldIdx) ;
LinStress = E1*LinStrain ;

% Generate Fit Curve
StrainFit = abs(Strain) ;
StressFit = E1.*StrainFit - E2*exp(-(Lam1./StrainFit)) - E3*exp(-(Lam2./StrainFit)) ;

% Plotting
PlotFig = figure('units', 'centimeters', 'position', [15, 10, 5*4, 4*4]);

plot(ReturnStrain, ReturnStress, '-', 'color', '#00b4d8','Linewidth', 12, 'DisplayName', ...
    'Plate Return') ; hold on ; 
plot(ReturnFiberStrain, ReturnStress, '-', 'color', '#90e0ef','Linewidth', 8, 'DisplayName', ...
    'Fiber Return') ; 
plot(HoldStrain, HoldStress, '-', 'color', '#0077b6','Linewidth', 12, 'DisplayName', ...
    'Hold') ;
plot(StretchStrain, StretchStress, '-', 'color', '#03045e','Linewidth', 12, 'DisplayName', ...
    'Stretch') ;

plot(LinStrain, LinStress, '-.', 'color', '#b80404', 'LineWidth', 8, 'DisplayName',...
    "Youngs Modulus") ;
plot(StrainFit, StressFit, '-.','LineWidth', 8, 'Color', "#00ed2f", 'DisplayName',...
    "Polymer Model") ;
plot(YieldStrain, YieldStress, 'x', 'color', '#b80404', 'LineWidth', 8, ...
    'MarkerSize', 30, 'DisplayName', 'Yield Point') ;

% Plot Details

ax = gca;
set(gca, 'FontSize', 24);
ax.Box = 'on';  % Turn on the box
set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
ax.LineWidth = 2 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;
xlabel('Strain') ;
ylabel('Stress (MPa)') ;

% Legened
lgd = legend('show', 'box', 'off', 'FontSize', 22, 'Location', 'northwest', 'edgecolor', 'none');
lgd.NumColumns = 2;
% hLegendPatch = findobj(lgd, 'type', 'patch');
% set(hLegendPatch, 'FaceAlpha', 0.5);  % 50% transparent background

xticks(linspace(0, 0.6, 5));
xlim([-0.08 0.66]) ;
yticks(linspace(0,150,6))

 % Plot Save
 path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 3 - Tensile Testing Methods & Analysis" ; 
 fileNameWidthWS = 'Stress Strain Data and Fit Plot - v2';
 filename1 = fullfile(path,fileNameWidthWS);  % Set your desired file name
 print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution


% ylimits = ylim ;
% yticks(round(linspace(ylimits(1), ylimits(2),6),1));
% ylim([0.9 2.1])




