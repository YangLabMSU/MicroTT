clear ; clc ; close all ;

% Fitting Data

% Evaluating Data
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 1 %:size(DataDirectory)

    % Get Path
    loadpath = DataDirectory(n,1);

    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat");
    load(DataPath);

    % Load in Fit Data
    FitPath = fullfile(DataDirectory(n,1), "Fit Data.mat");
    load(FitPath);

    % Load your data (replace with actual data loading method)
    stress = ProcessedData.Stress;
    fiberstrain = ProcessedData.FiberStrain;
    platestrain = ProcessedData.PlateStrain;
    time = ProcessedData.Time;

    % Combine and sort peaks and troughs
    StressPks = [ FitData.Stress.Pk, FitData.Stress.Pktime ; FitData.Stress.Tr, FitData.Stress.Trtime ] ;
    StressPks = sortrows(StressPks, 2);

    % Define the sine wave function
    sine_wave = @(params, t) params(1) * sin(params(2) * t + params(3)) + params(4);

    % Initial guess for the parameters [Amplitude, Frequency, Phase, Offset]
    % Adjust frequency to be in the form of 2*pi/Period
    initial_guess = [mean(FitData.Stress.Pk), 2 * pi / FitData.Stress.Period, 0, 0];

    % Fit the sine wave to the data using lsqcurvefit
    options = optimset('Display', 'off');
    params_fit = lsqcurvefit(sine_wave, initial_guess, StressPks(:,2), StressPks(:,1), [], [], options);

    % Extract the fitted parameters
    amplitude_fit = params_fit(1);
    frequency_fit = params_fit(2);
    phase_fit = params_fit(3);
    offset_fit = params_fit(4);

    % Generate fitted sine wave for plotting
    time_fit = linspace(min(StressPks(:,2)), max(StressPks(:,2)), 2000);
    sine_fit = amplitude_fit * sin(frequency_fit * time_fit + phase_fit) + offset_fit;

    % Plot the original data points and the fitted sine wave
    PlotFig = figure('Units', 'inches', 'Position', [8, 1, 12, 8]);
    plot(time, stress, 'linewidth', 3); hold on;
    plot(StressPks(:,2), StressPks(:,1), 'xg', 'MarkerSize', 10, 'linewidth', 2);
    plot(time_fit, sine_fit, '-c', 'linewidth', 2);

    % Label axes and add a title
    xlabel('Time');
    ylabel('Stress');
    title('Stress Data with Sine Wave Fit');
    legend('Original Stress Data', 'Peaks and Troughs', 'Fitted Sine Wave');
    grid on;



end