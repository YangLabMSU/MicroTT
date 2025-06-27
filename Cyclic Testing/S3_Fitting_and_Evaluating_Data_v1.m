clear ; clc ; close all ;

% Fitting Data

% Evaluating Data
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;
%%

for n = 1:size(DataDirectory)

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

    % FiberStrainPks
    FiberStrainPks = [ FitData.Fiber.Pk, FitData.Fiber.Pktime ; FitData.Fiber.Tr, FitData.Fiber.Trtime ] ;
    FiberStrainPks = sortrows(FiberStrainPks, 2);

    % PlateStrainPks
    PlateStrainPks = [ FitData.Plate.Pk, FitData.Plate.Pktime ; FitData.Plate.Tr, FitData.Plate.Trtime ] ;
    PlateStrainPks = sortrows(PlateStrainPks, 2);

    % Initial guesses for the parameters for each sine wave
    initial_guess1 = [mean(FitData.Stress.Pk), 2 * pi / FitData.Stress.Period, 0, 0];
    initial_guess2 = [mean(FitData.Fiber.Pk), 2 * pi / FitData.Fiber.Period, 0, 0];
    initial_guess3 = [mean(FitData.Plate.Pk), 2 * pi / FitData.Plate.Period, 0, 0];


    % Time range for fitting
    timeRange = [min(StressPks(:,2)), max(StressPks(:,2))];

    % Fit the sine waves
    [params_fit1, sine_fit1, time_fit1] = fitSineWave(StressPks, initial_guess1, timeRange);
    [params_fit2, sine_fit2, time_fit2] = fitSineWave(FiberStrainPks, initial_guess2, timeRange);
    [params_fit3, sine_fit3, time_fit3] = fitSineWave(PlateStrainPks, initial_guess3, timeRange);

    % Plot the original data points and the fitted sine wave
    PlotFig = figure('Units', 'inches', 'Position', [8, 1, 12, 8]);
    subplot(3,1,1) ;
    plot(time, stress, 'linewidth', 3); hold on;
    plot(StressPks(:,2), StressPks(:,1), 'xg', 'MarkerSize', 10, 'linewidth', 2);
    plot(time_fit1, sine_fit1, '-c', 'linewidth', 2);
    xlabel('Time');
    ylabel('Stress');
    title('Stress');
    legend('Original Stress Data', 'Peaks and Troughs', 'Fitted Sine Wave');
    grid on;


    subplot(3,1,2) ;
    plot(time, fiberstrain, 'linewidth', 3); hold on;
    plot(FiberStrainPks(:,2), FiberStrainPks(:,1), 'xg', 'MarkerSize', 10, 'linewidth', 2);
    plot(time_fit2, sine_fit2, '-c', 'linewidth', 2);
    xlabel('Time');
    ylabel('Fiber Strain');
    title('Fiber Strain');
    legend('Original Stress Data', 'Peaks and Troughs', 'Fitted Sine Wave');
    grid on;

    subplot(3,1,3) ;
    plot(time, platestrain, 'linewidth', 3); hold on;
    plot(PlateStrainPks(:,2), PlateStrainPks(:,1), 'xg', 'MarkerSize', 10, 'linewidth', 2);
    plot(time_fit3, sine_fit3, '-c', 'linewidth', 2);
    xlabel('Time');
    ylabel('Plate Strain');
    title('Fiber Strain');
    legend('Original Stress Data', 'Peaks and Troughs', 'Fitted Sine Wave');
    grid on;


    % Determine whether to save the data or not
    answer = questdlg('Look Good?','Double Check','Yes','No','Yes');
    switch answer
        case 'Yes'

            % Extract amplitudes and phases
            sigma_0 = params_fit1(1);
            epsilon_fiber_0 = params_fit2(1);
            epsilon_plate_0 = params_fit3(1);
            phase_stress = params_fit1(3);
            phase_fiber_strain = params_fit2(3);
            phase_plate_strain = params_fit3(3);

            % Calculate the phase difference
            deltafiber = phase_stress - phase_fiber_strain;
            deltaplate = phase_stress - phase_plate_strain;

            % Calculate the storage modulus E' and loss modulus E''
            E_fiber_prime = (sigma_0 / epsilon_fiber_0) * cos(deltafiber);
            E_fiber_double_prime = (sigma_0 / epsilon_fiber_0) * sin(deltafiber);

            E_plate_prime = (sigma_0 / epsilon_plate_0) * cos(deltaplate);
            E_plate_double_prime = (sigma_0 / epsilon_plate_0) * sin(deltaplate);


            % Display the results
            fprintf('Storage Modulus, Fiber & Plate %f & %f\n', E_fiber_prime, E_plate_prime);
            fprintf('Loss Modulus, Fiber & Plate: %f & %f\n', E_fiber_double_prime, E_plate_double_prime);

            FitData.Stress.FitParams = params_fit1 ;
            FitData.Fibers.FitParams = params_fit2 ;
            FitData.Plate.FitParams = params_fit3 ;

            FitData.Fiber.Storage = E_fiber_prime ; 
            FitData.Fiber.Loss = E_fiber_double_prime ;
            FitData.Plate.Storage = E_plate_prime ; 
            FitData.Plate.Loss = E_plate_double_prime ; 

            savepath = fullfile(loadpath, "Fit Data.mat") ;
            save(savepath, "FitData") ;
            close all ;

        case 'No'

            close all ;

    end


end