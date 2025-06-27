clear ; clc ; close ;

% Evaluating Data
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ; 

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 2 %1:size(DataDirectory,1)

    % Get Path
    loadpath = DataDirectory(n,1) ;
    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat") ;
    load(DataPath) ;

    % Stress, Strain, Time
    stress = ProcessedData.Stress ;
    strain = ProcessedData.FiberStrain ;
    time = ProcessedData.Time ;

    % Plot the data
    PlotFig = figure();
    PlotFig.Units = 'inches' ;
    PlotFig.Position = [8,1,12,8] ;

    subplot(2,3,[1 2]);
    plot(time, strain);
    xlabel('Time');
    ylabel('Strain');
    title('Strain vs Time');

    subplot(2,3,[4 5]);
    plot(time, stress);
    xlabel('Time');
    ylabel('Stress');
    title('Stress vs Time');

    subplot(2,3,[3,6]);
    plot(strain, stress);
    xlabel('Strain');
    ylabel('Stress');
    title('Stress vs Strain');

    % Find peaks in strain data
    [pks_strain, locs_strain] = findpeaks(strain, time, 'MinPeakHeight',15*10^(-3));

    % Find peaks in stress data
    [pks_stress, locs_stress] = findpeaks(stress, time,'MinPeakHeight', 7.5);

    % Plot the data with peaks identified
    PeakFig = figure();
    PeakFig.Units = 'inches' ;
    PeakFig.Position = [8,1,12,8] ;

    subplot(2,1,1);
    plot(time, strain, 'b');
    hold on;
    plot(locs_strain, pks_strain, 'r*');
    xlabel('Time');
    ylabel('Strain');
    title('Strain Peaks');

    subplot(2,1,2);
    plot(time, stress, 'b');
    hold on;
    plot(locs_stress, pks_stress, 'r*');
    xlabel('Time');
    ylabel('Stress');
    title('Stress Peaks');

    % Calculate the average peak-to-peak distance (period) for strain
    period_strain = mean(diff(locs_strain));

    % Calculate the average peak-to-peak distance (period) for stress
    period_stress = mean(diff(locs_stress));

    % Calculate the average amplitude for strain
    amplitude_strain = mean(pks_strain);

    % Calculate the average amplitude for stress
    amplitude_stress = mean(pks_stress);

    % Find the first and last peaks
    first_peak_time = min(locs_strain(1), locs_stress(1));
    last_peak_time = max(locs_strain(end), locs_stress(end));

    % Calculate the trim points
    average_period = mean([period_strain, period_stress]);
    start_time = first_peak_time - 1.5 * average_period/2;
    end_time = last_peak_time + 1.5 * average_period/2;

    % Display results
    disp(['Average Period for Strain: ', num2str(period_strain)]);
    disp(['Average Period for Stress: ', num2str(period_stress)]);
    disp(['Average Amplitude for Strain: ', num2str(amplitude_strain)]);
    disp(['Average Amplitude for Stress: ', num2str(amplitude_stress)]);


    % Find the indices corresponding to the trim points
    start_idx = find(time >= start_time, 1);
    end_idx = find(time <= end_time, 1, 'last');

    % Trim the data
    trimmed_time = time(start_idx:end_idx);
    trimmed_time = trimmed_time - trimmed_time(1) ;
    trimmed_strain = strain(start_idx:end_idx);
    trimmed_stress = stress(start_idx:end_idx);

    % Define sinusoidal model function
    sinusoidal_model = @(b, x) b(1) * sin(b(2) * x + b(3)) + b(4);

    % Initial guess for parameters [amplitude, angular frequency, phase, offset]
    initial_guess_stress = [amplitude_stress, 2*pi/period_stress, 0, mean(stress)];
    initial_guess_strain = [amplitude_strain, 2*pi/period_strain, 0, mean(strain)];

    % Fit the sinusoidal model to the stress data
    fit_params_stress = lsqcurvefit(sinusoidal_model, initial_guess_stress, trimmed_time, trimmed_stress);

    % Fit the sinusoidal model to the strain data
    fit_params_strain = lsqcurvefit(sinusoidal_model, initial_guess_strain, trimmed_time, trimmed_strain);

    % Generate fitted data
    fitted_stress = sinusoidal_model(fit_params_stress, trimmed_time);
    fitted_strain = sinusoidal_model(fit_params_strain, trimmed_time);

    % Plot the fitted model
    figure;
    subplot(2,1,1);
    plot(trimmed_time, trimmed_stress, 'b', 'DisplayName', 'Original Stress Data');
    hold on;
    plot(trimmed_time, fitted_stress, 'r', 'DisplayName', 'Fitted Stress Model');
    xlabel('Time');
    ylabel('Stress');
    title('Stress vs Time with Sinusoidal Fit');
    legend show;

    subplot(2,1,2);
    plot(trimmed_time, trimmed_strain, 'b', 'DisplayName', 'Original Strain Data');
    hold on;
    plot(trimmed_time, fitted_strain, 'r', 'DisplayName', 'Fitted Strain Model');
    xlabel('Time');
    ylabel('Strain');
    title('Strain vs Time with Sinusoidal Fit');
    legend show;

    % Extract parameters from the fitted models
    amplitude_stress = fit_params_stress(1);
    frequency_stress = fit_params_stress(2);
    phase_stress = fit_params_stress(3);
    offset_stress = fit_params_stress(4);

    amplitude_strain = fit_params_strain(1);
    frequency_strain = fit_params_strain(2);
    phase_strain = fit_params_strain(3);
    offset_strain = fit_params_strain(4);

    % Calculate the angular frequency (should be similar for both stress and strain)
    angular_frequency = frequency_stress; % or frequency_strain

    % Calculate Storage Modulus E' and Loss Modulus E''
    % E' = amplitude_stress / amplitude_strain * cos(phase_stress - phase_strain)
    % E'' = amplitude_stress / amplitude_strain * sin(phase_stress - phase_strain)

    storage_modulus = amplitude_stress / amplitude_strain * cos(phase_stress - phase_strain);
    loss_modulus = amplitude_stress / amplitude_strain * sin(phase_stress - phase_strain);

    % Display the results
    disp(['Storage Modulus (E"): ', num2str(storage_modulus)]);
    disp(['Loss Modulus (E''): ', num2str(loss_modulus)]);


end
