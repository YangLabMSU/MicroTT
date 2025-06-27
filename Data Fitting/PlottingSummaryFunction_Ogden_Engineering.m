function PlottingSummaryFunction_Ogden_Engineering(Stress, Strain, lambda, Parameters, CriticalPts, FittingValues, GoodnessOfFit)

% Set Up Figure
PlotFig = figure('units', 'centimeters', 'Position', [13.5, 0.5, 18, 18]) ;

YieldIdx = CriticalPts(1) ;

% Assign Fitting Data
YieldStress = Stress(YieldIdx) ;
YieldStrain = Strain(YieldIdx) ;

% Extract parameters
mu = FittingValues(1:2:end);     % Odd indices: mu_k
alpha = FittingValues(2:2:end);  % Even indices: alpha_k

% Initialize stress
FittedStress = zeros(size(lambda));

% Compute stress for each term
for k = 1:length(mu)
    FittedStress = FittedStress + (2 * mu(k) / alpha(k)) .* ...
        (lambda.^alpha(k) - (1 ./ sqrt(lambda)).^alpha(k));
end

FittedStress = FittedStress ./ (1+Strain) ; 

Rsqrd = GoodnessOfFit(1) ;
RMSE = GoodnessOfFit(2) ;

% Parameters
Materials = Parameters(1) ;
Substrate = Parameters(2) ;
TestDate = Parameters(3) ;
Conditions = Parameters(4) ;
ArrayPosition = Parameters(5) ;
BeamStiffness = Parameters(7) ;
Power = (double(Parameters(8))/100)*50 ;
WriteSpeed = Parameters(9) ;
FWidth = Parameters(10) ;
FHeight = Parameters(11) ;
Slice = Parameters(12) ;
Hatch = Parameters(13) ;
Style = Parameters(14) ;
SEMArea = Parameters(15) ;
FiberLength = Parameters(16) ;
StrainDistance = Parameters(17) ;
StrainRate = Parameters(18) ;


% Plotting
% subplot(1,3,[1 2])
axes('Position', [0.20, 0.20, 0.75, 0.75]);
% Original Stress Strian Data
plot(Strain, Stress, '-', 'color', '#11029e', 'Linewidth', 5, 'DisplayName', ...
    'Experiment Data') ; hold on ;

% Plot the Linear Portion of the Curve
plot(Strain, FittedStress, '-.', 'color', '#b80404', 'LineWidth', 4, 'DisplayName',...
    "Ogden Model") ;

% Mark the Yield, Equilibrium Points
plot(YieldStrain, YieldStress, 'x', 'color', '#b80404', 'LineWidth', 4, ...
    'MarkerSize', 15, 'DisplayName', 'Yield Point') ;

% Plot Details
% legend('Location', 'northwest') ;
% legend('boxoff') ; 
box on; grid on; ax = gca ;
set(ax, 'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'bold',...
    'LineWidth', 1.5, 'TickLength', [ 0.015, 0.2 ]);

% Titles and Axes Lables
title('IP-S', 'FontSize', 18) ;
xlim([0 1]);
xlabel('Strain', 'FontSize', 15, 'FontName', 'Arial');
ylabel('Stress (MPa)', 'FontSize', 15, 'FontName', 'Arial');

ax.LineWidth = 1.25 ; % Increase the axis line width
ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
grid on ;

hold off ;

% subplot(1,3,3) ;
% cla ;
% axis off;

% Adding Experiment Details Text
ExpMaterialString = sprintf("Material: %s", Materials) ;
ExpSubString = sprintf("Substrate: %s", Substrate ) ;
ExpTDString = sprintf("Test Date: %s", TestDate) ;
ExpCondString = sprintf("Conditions: %s", Conditions ) ;
ExpArrayString = sprintf("Array Position: %s", ArrayPosition) ;
ExpWSString = sprintf("Writing Speed (mm/s): %s", WriteSpeed ) ;
ExpWPString = sprintf("Writing Power (mW): %0.2f", Power ) ;
ExpFWHString = sprintf("Fiber Design Width x Height (um): %s x %s", FWidth, FHeight) ;
ExpSliceHatchString = sprintf("Fiber Slice x Hatch (um): %s x %s", ...
    Slice, Hatch) ;
ExpHatchStyleString = sprintf("Fiber Hatch Style: %s", Style) ;
ExpAreaString = sprintf("Fiber Area (um^2): %s", SEMArea ) ;
ExpLengthString = sprintf("Fiber Length (um): %s", FiberLength ) ;
ExpBeamString = sprintf("Beam Stiffness (uN/um): %s", BeamStiffness) ;
ExpDispString = sprintf("Forcing Displacement (um): %s", StrainDistance ) ;
ExpDRString = sprintf("Forcing Rate (um/s): %s", StrainRate ) ;

% Adding Fitting Details Text
ExpYStressString = sprintf("Yield Stress (MPa): %.1f", YieldStress) ;
ExpYStrainString = sprintf("Yield Strain: %.3f", YieldStrain) ;

ExpMod1String = sprintf("mu_1: %.1f", mu(1)) ;
ExpMod2String = sprintf("mu_2: %.1f", mu(2)) ;
ExpStrainCoeff1String = sprintf("alpha_1: %.3f", alpha(1) );
ExpStrainCoeff2String = sprintf("alpha_2: %.3f", alpha(2) );

ExpErrorString1 = sprintf("R^2 = %.4f", Rsqrd) ;
ExpErrorString2 = sprintf("RMSE = %.3f", RMSE) ;

% text(-0.15, 0.5, {ExpMaterialString, ExpSubString, ExpTDString, ExpCondString, ExpArrayString, ...
%     ExpWSString,...
%     ExpWPString, ExpFWHString, ExpSliceHatchString, ExpHatchStyleString, "", ...
%     ExpBeamString, ExpDispString, ExpDRString, "", ExpAreaString, ExpLengthString, "", ...
%     ExpYStressString, ExpYStrainString, "", ExpMod1String, ExpMod2String...
%     ExpStrainCoeff1String, ExpStrainCoeff2String, ""...
%     ExpErrorString1, ExpErrorString2},...
%     'FontSize', 13, 'FontName', 'Arial') ;

set(gca, 'FontSize', 20);

hold off ;

% Saving
parts = split(Substrate, '/');  % Split the string by hyphens
month = parts{1};
day = parts{2};
year = parts{3};  % Assuming the year is in the 21st century
SubSave = month + "-" + day + "-" + year;

parts = split(TestDate, '/');  % Split the string by hyphens
month = parts{1};
day = parts{2};
year = parts{3};  % Assuming the year is in the 21st century
TDSave = month + "-" + day + "-" + year;

% Save in Folder, and Save in a All Experiment Folder
figname = sprintf("%s_%s_%s_%s", Materials, SubSave, TDSave, ArrayPosition) ;

% Define the directory where the figure will be saved
newFolder = 'D:\TPP uTT IP-PDMS Analysis\Materials Comparison\Stress-Strain Curves' ;

% Check if the folder exists, if not, create it
if ~exist(newFolder, 'dir')
    mkdir(newFolder);
end

filename = fullfile(newFolder, figname + ".jpg") ; 
print(filename, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution
filename = fullfile(newFolder, figname + ".tiff") ; 
exportgraphics(gcf, filename, 'Resolution', 300);
%pause(.25);
close all ; 

end
