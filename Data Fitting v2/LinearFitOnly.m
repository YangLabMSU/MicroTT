% Linear Fit only for IP-PDMS

% Breaking down and fitting the stress strain curve
load('All IP-PDMS - Data.mat');
whos StretchExperimentData
IPPDMSFitValues = zeros(size(StretchExperimentData, 1), 1);

for n = 1:size(StretchExperimentData, 1)
    Stress = StretchExperimentData{n,2};
    Strain = StretchExperimentData{n,3};

    % Fit up to strain of 0.4
    ValidIDx = Strain <= 0.4;
    StrainFit = Strain(ValidIDx);
    StressFit = Stress(ValidIDx);

    % Fit a linear model
    LFT = fittype({'x'});
    LinearModel = fit(StrainFit, StressFit, LFT);
    E1 = LinearModel.a;

    figure('Units','centimeters','Position',[13.5, 0.5, 18, 18]);
axes('Position', [0.20, 0.20, 0.75, 0.75]);

plot(Strain, Stress, '-', 'Color', '#11029e', 'LineWidth', 5); hold on;
plot(StrainFit, E1*StrainFit, '-.', 'Color', '#b80404', 'LineWidth', 4);

% Labels and title with same fonts and sizes as Ogden
title('IP-PDMS', 'FontSize', 18, 'FontName', 'Arial');
xlabel('Strain', 'FontSize', 15, 'FontName', 'Arial');
ylabel('Stress (MPa)', 'FontSize', 15, 'FontName', 'Arial');

% Match axis formatting exactly
ax = gca;
set(ax, 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold', ...
    'LineWidth', 1.5, 'TickLength', [0.015, 0.2]);
ax.LineWidth = 1.25;
ax.TickLength = [0.01 0.01];
xlim([0 1]);
box on; grid on;

hold off;


    % Store results
    datatxt = sprintf("E1: %0.3f", E1);
    disp(datatxt);
    StretchExperimentData{n,5} = E1;
    IPPDMSFitValues(n, 1) = E1;

    % Save every 5th plot
    if mod(n, 5) == 0
        basepath = "D:\TPP uTT IP-PDMS Analysis\Materials Comparison\Stress-Strain Curves";
        jpgfile = fullfile(basepath, sprintf('IP-PDMSStressStrainPlot_%d.jpg', n));
        tiffile = fullfile(basepath, sprintf('IP-PDMSStressStrainPlot_%d.tiff', n));
        print(gcf, jpgfile, '-djpeg', '-r300');
        exportgraphics(gcf, tiffile, 'Resolution', 300);
    end

    pause(0.5);
    close all;
end

save("Stretch Experiment Linear Fit - IP-PDMS - v2.mat", "StretchExperimentData");
save("IP-PDMS Fit Values for Comparison.mat", "IPPDMSFitValues");
