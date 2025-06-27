clear ; clc ; close ;

% Evaluating Data
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ; 

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 1 %1:size(DataDirectory,1)

    % Get Path
    loadpath = DataDirectory(n,1) ;
    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat") ;
    load(DataPath) ;

% Load your data (replace with actual data loading method)
stress = ProcessedData.Stress;
strain = ProcessedData.FiberStrain;
time = ProcessedData.Time;

% Find peaks in strain and stress data
[pks_strain, locs_strain] = findpeaks(strain, time, 'MinPeakHeight', 15e-3);
[pks_stress, locs_stress] = findpeaks(stress, time, 'MinPeakHeight', 7.5);

% Calculate average period and amplitude
period_strain = mean(diff(locs_strain));
period_stress = mean(diff(locs_stress));
amplitude_strain = mean(pks_strain);
amplitude_stress = mean(pks_stress);
average_period = mean([period_strain, period_stress]);

% Find trim points
first_peak_time = min(locs_strain(1), locs_stress(1));
last_peak_time = max(locs_strain(end), locs_stress(end));
start_time = first_peak_time - 1.5 * average_period / 2;
end_time = last_peak_time + 1.5 * average_period / 2;

% Trim the data
start_idx = find(time >= start_time, 1);
end_idx = find(time <= end_time, 1, 'last');
trimmed_time = time(start_idx:end_idx) - time(start_idx);
trimmed_strain = strain(start_idx:end_idx);
trimmed_stress = stress(start_idx:end_idx);

% Define the model function
% y(t) = A * exp(-lambda * t) * sin(omega * t + phi) + (C0 + C1 * t)
decaying_sinusoidal_model_with_linear_offset = @(b, x) ...
    b(1) * exp(-b(2) * x) .* sin(b(3) * x + b(4)) + (b(5) + b(6) * x);

% Initial guesses for parameters [A, lambda, omega, phi, C0, C1]
initial_guess_stress = [amplitude_stress, 0.01, 2*pi/average_period, 0, mean(stress), 0];
initial_guess_strain = [amplitude_strain, 0.01, 2*pi/average_period, 0, mean(strain), 0];

% Fit the model to the stress data
fit_params_stress = lsqcurvefit(decaying_sinusoidal_model_with_linear_offset, initial_guess_stress, trimmed_time, trimmed_stress);

% Fit the model to the strain data
fit_params_strain = lsqcurvefit(decaying_sinusoidal_model_with_linear_offset, initial_guess_strain, trimmed_time, trimmed_strain);

% Generate fitted data
fitted_stress = decaying_sinusoidal_model_with_linear_offset(fit_params_stress, trimmed_time);
fitted_strain = decaying_sinusoidal_model_with_linear_offset(fit_params_strain, trimmed_time);

% Plot the fitted model
figure;
subplot(3,1,1);
plot(trimmed_time, trimmed_stress, 'b', 'DisplayName', 'Original Stress Data');
hold on;
plot(trimmed_time, fitted_stress, 'r', 'DisplayName', 'Fitted Stress Model');
xlabel('Time'); ylabel('Stress'); title('Stress vs Time with Decaying Sinusoidal and Linear Offset');
legend show;

subplot(3,1,2);
plot(trimmed_time, trimmed_strain, 'b', 'DisplayName', 'Original Strain Data');
hold on;
plot(trimmed_time, fitted_strain, 'r', 'DisplayName', 'Fitted Strain Model');
xlabel('Time'); ylabel('Strain'); title('Strain vs Time with Decaying Sinusoidal and Linear Offset');
legend show;

% Plot the decay term
% Plot the decay term
decay_term_stress = fit_params_stress(1) * exp(-fit_params_stress(2) * trimmed_time);
decay_term_strain = fit_params_strain(1) * exp(-fit_params_strain(2) * trimmed_time);

subplot(3,1,3);
plot(trimmed_time, decay_term_stress, 'g', 'DisplayName', 'Decay Term (Stress)');
hold on;
plot(trimmed_time, decay_term_strain, 'm', 'DisplayName', 'Decay Term (Strain)');
xlabel('Time'); ylabel('Amplitude'); title('Decay Term over Time');
legend show;

% Extract parameters from the fitted models
amplitude_stress = fit_params_stress(1);
phase_stress = fit_params_stress(4);
amplitude_strain = fit_params_strain(1);
phase_strain = fit_params_strain(4);

% Calculate Storage Modulus E' and Loss Modulus E''
% E' = amplitude_stress / amplitude_strain * cos(phase_stress - phase_strain)
% E'' = amplitude_stress / amplitude_strain * sin(phase_stress - phase_strain)

storage_modulus = amplitude_stress / amplitude_strain * cos(phase_stress - phase_strain);
loss_modulus = amplitude_stress / amplitude_strain * sin(phase_stress - phase_strain);

% Display the results
disp(['Storage Modulus (E''): ', num2str(storage_modulus)]);
disp(['Loss Modulus (E''): ', num2str(loss_modulus)]);

end
