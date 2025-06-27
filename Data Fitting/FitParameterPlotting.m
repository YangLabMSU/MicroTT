function FitParameterPlotting(data, parameters)

Mods = data(:, [1 2 4]) ;
Lams = data(:, [3 5]) ;

% Create box plot
subplot(1,5,[1,2]) ;
boxplot(Mods, 'Labels', {'E_1', 'E_2', 'E_3'}); hold on ;
title('Box Plot of Fitting Parameters');
%xlabel('Fitting Parameters');
%ylabel('Values');
ylim([0 2000]) ;
yticks(linspace(0, 2000, 5));

% Calculate mean and standard deviation
Modmeans = mean(Mods);
Modstddevs = std(Mods);

% Create scatter plot with error bars
errorbar(1:3, Modmeans, Modstddevs, "LineStyle", "none");
set(gca, 'XTick', 1:3, 'XTickLabel', {'E_1', 'E_2', 'E_3'});
title('Moduli Fitting Parameters');
xlabel('Fitting Parameters');
ylabel('Moduli (MPa)');

% Overlay individual data points
numParams = size(Mods, 2);
for i = 1:numParams
    % Randomly jitter the x-position of the data points for better visibility
    jitteredX = i + (rand(size(Mods, 1), 1) - 0.5) * 0.1;
    scatter(jitteredX, Mods(:, i), 'x', 'LineWidth', 3, 'MarkerEdgeColor','b', 'MarkerEdgeAlpha', 0.5);
end

% Turn on the y-grid
grid on;
set(gca, 'FontSize', 15, 'FontName', 'Arial');

hold off ;

% Create box plot
subplot(1,5,[3, 4]) ;
boxplot(Lams, 'Labels', {'Lambda_1', 'Lambda_2'}); hold on ;
title('Box Plot of Fitting Parameters');
%xlabel('Fitting Parameters');
ylabel('Strian Coefficients');
ylim([0 1.75]) ;
yticks(linspace(0, 1.75, 5));

% Calculate mean and standard deviation
Lammeans = mean(Lams);
Lamstddevs = std(Lams);

% Create scatter plot with error bars
errorbar(1:2, Lammeans, Lamstddevs, "LineStyle","none");
set(gca, 'XTick', 1:2, 'XTickLabel', {'Lambda_1', 'Lambda_2'});
title('Strain Coefficient Parameters');
%xlabel('Fitting Parameters');
ylabel('Strian Coefficients');

% Overlay individual data points
numParams = size(Lams, 2);
for i = 1:numParams
    % Randomly jitter the x-position of the data points for better visibility
    jitteredX = i + (rand(size(Lams, 1), 1) - 0.5) * 0.25 ;
    scatter(jitteredX, Lams(:, i), 'xb', 'LineWidth', 3, 'MarkerEdgeColor','b', 'MarkerEdgeAlpha', 0.5);
end

% Turn on the y-grid
grid on;
set(gca, 'FontSize', 15, 'FontName', 'Arial');

hold off ;

subplot(1,5,5) ;
cla ;
axis off;


Materials = parameters(1) ;
Substrate = parameters(2) ;
Conditions = parameters(3) ;
ArrayPosition = parameters(4) ;
BeamStiffness = parameters(6) ;
Power = (double(parameters(6))/100)*50 ;
WriteSpeed = parameters(7) ;
FWidth = parameters(8) ;
FHeight = parameters(9) ;
Slice = parameters(10) ;
Hatch = parameters(11) ;
Style = parameters(12) ;
SEMArea = parameters(13) ;
FiberLength = parameters(14) ;
StrainDistance = parameters(15) ;
StrainRate = parameters(16) ;

Mod1 = Modmeans(1) ;
Mod1Std = Modstddevs(1) ;
Mod2 = Modmeans(2) ;
Mod2Std = Modstddevs(3) ;
Mod3 = Modmeans(3) ;
Mod3Std = Modstddevs(3) ;
SC1 = Lammeans(1) ;
SC1Std = Lamstddevs(1) ;
SC2 = Lammeans(2) ;
SC2Std = Lamstddevs(2) ;

% Adding Experiment Details Text
ExpMaterialString = sprintf("Material: %s", Materials) ;
ExpSubString = sprintf("Substrate: %s", Substrate ) ;
ExpCondString = sprintf("Conditions: %s", Conditions ) ;
ExpArrayString = sprintf("Array Positions: %s", ArrayPosition) ;
ExpWSString = sprintf("Writing Speed (mm/s): %s", WriteSpeed ) ;
ExpWPString = sprintf("Writing Power (mW): %0.2f", Power ) ;
ExpFWHString = sprintf("Fiber Design Width x Height (um): %s x %s", FWidth, FHeight) ;
ExpSliceHatchString = sprintf("Fiber Slice x Hatch (um): %s x %s", ...
    Slice, Hatch) ;
ExpHatchStyleString = sprintf("Fiber Hatch Style: %s", Style) ;
ExpAreaString = sprintf("Average Fiber Area (um^2): %s", SEMArea ) ;
ExpLengthString = sprintf("Average Fiber Length (um): %s", FiberLength ) ;
ExpBeamString = sprintf("Beam Stiffness (uN/um): %s", BeamStiffness) ;
ExpDispString = sprintf("Forcing Displacement (um): %s", StrainDistance ) ;
ExpDRString = sprintf("Forcing Rate (um/s): %s", StrainRate ) ;

ExpMod1String = sprintf("1st Modulus: %.1f +- %.1f",Mod1, Mod1Std) ;
ExpMod2String = sprintf("2nd Modulus: %.1f +- %.1f",Mod2, Mod2Std) ;
ExpStrainCoeff1String = sprintf("1st Strain Coeffs: %.3f +- %.3f", SC1, SC1Std );
ExpMod3String = sprintf("3rd Modulus: %.1f +- %.1f",Mod3, Mod3Std) ;
ExpStrainCoeff2String = sprintf("2nd Strain Coeffs: %.3f +- %.3f", SC2, SC2Std );

text(-0.15, 0.5, {ExpMaterialString, ExpSubString, ExpCondString, ExpArrayString, ...
    ExpWSString, ExpWPString, ExpFWHString, ExpSliceHatchString, ExpHatchStyleString, "", ...
    ExpBeamString, ExpDispString, ExpDRString, "",...
    ExpAreaString, ExpLengthString, "",...
    ExpMod1String, ExpMod2String, ExpStrainCoeff1String, ExpMod3String,...
    ExpStrainCoeff2String}, 'FontSize', 13, 'FontName', 'Arial') ;


end