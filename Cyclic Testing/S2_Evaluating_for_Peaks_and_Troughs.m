clear ; clc ; close ;

% Evaluating Data
%folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;

% Generate Data Directory
DataDirectory = LoadRawDataExperimentDirectory_Folder(folderpath) ;

for n = 4 %:size(DataDirectory,1)

    % Get Path
    loadpath = DataDirectory(n,1) ;

    % Load in Data and Parameters
    DataPath = fullfile(DataDirectory(n,1), "Processed Data.mat") ;
    load(DataPath) ;

    % Load your data (replace with actual data loading method)
    stress = ProcessedData.Stress;
    fiberstrain = ProcessedData.FiberStrain;
    platestrain = ProcessedData.PlateStrain;
    time = ProcessedData.Time;

    Check = 0 ;
    PkDistance = 50 ;
    PkMult = 0.2 ; 

    while Check == 0

        % Initial peak detection
        [pks_platestrain, ~] = findpeaks(platestrain, time, 'MinPeakHeight', mean(platestrain));
        [pks_fiberstrain, ~] = findpeaks(fiberstrain, time, 'MinPeakHeight', mean(fiberstrain));
        [pks_stress, ~] = findpeaks(stress, time, 'MinPeakHeight', mean(stress));

        % Iterate once on peaks
        [pks_platestrain, locs_platestrain] = findpeaks(platestrain, 'MinPeakHeight', mean(pks_platestrain) - PkMult * mean(pks_platestrain), 'MinPeakDistance', PkDistance);
        [pks_fiberstrain, locs_fiberstrain] = findpeaks(fiberstrain, 'MinPeakHeight', mean(pks_fiberstrain) - PkMult * mean(pks_fiberstrain), 'MinPeakDistance', PkDistance);
        [pks_stress, locs_stress] = findpeaks(stress, 'MinPeakHeight', mean(pks_stress) - PkMult * mean(pks_stress), 'MinPeakDistance', PkDistance) ;

        % Find Minimum Stress and Strain Peaks
        adj_platestrain = platestrain(locs_platestrain(1):locs_platestrain(end));
        adj_fiberstrain = fiberstrain(locs_fiberstrain(1):locs_fiberstrain(end));
        ajd_stress = stress(locs_stress(1):locs_stress(end)) ;


        % Detect troughs (negative peaks)
        [trs_platestrain, tlocs_platestrain] = findpeaks(-adj_platestrain, 'MinPeakHeight', mean(-adj_platestrain), 'MinPeakDistance', PkDistance);
        [trs_fiberstrain, tlocs_fiberstrain] = findpeaks(-adj_fiberstrain, 'MinPeakHeight', mean(-adj_fiberstrain), 'MinPeakDistance', PkDistance);
        [trs_stress, tlocs_stress] = findpeaks(-ajd_stress, 'MinPeakHeight', mean(-ajd_stress),'MinPeakDistance', PkDistance);

        % Negate to get the actual trough values
        trs_platestrain = -trs_platestrain;
        trs_fiberstrain = -trs_fiberstrain;
        trs_stress = -trs_stress;

        % Adjust locations back to the original time scale
        tlocs_platestrain = tlocs_platestrain + locs_platestrain(1) - 1;
        tlocs_fiberstrain = tlocs_fiberstrain + locs_fiberstrain(1) - 1;
        tlocs_stress = tlocs_stress + locs_stress(1) - 1 ;

        % Plot the data with peaks and troughs identified
        PeakFig = figure();
        PeakFig.Units = 'inches';
        PeakFig.Position = [8, 1, 12, 8];

        subplot(3, 1, 1);
        plot(time, fiberstrain, 'b');
        hold on;
        plot(time(locs_fiberstrain), pks_fiberstrain, 'r*');
        plot(time(tlocs_fiberstrain), trs_fiberstrain, 'go');
        xlabel('Time');
        ylabel('Fiber Strain');
        title('Fiber Strain Peaks and Troughs');

        subplot(3, 1, 2);
        plot(time, platestrain, 'b');
        hold on;
        plot(time(locs_platestrain), pks_platestrain, 'r*');
        plot(time(tlocs_platestrain), trs_platestrain, 'go');
        xlabel('Time');
        ylabel('Plate Strain');
        title('Plate Strain Peaks and Troughs');

        subplot(3, 1, 3);
        plot(time, stress, 'b');
        hold on;
        plot(time(locs_stress), pks_stress, 'r*');
        plot(time(tlocs_stress), trs_stress, 'go');
        xlabel('Time');
        ylabel('Stress');
        title('Stress Peaks');

        % Calculate the average peak-to-peak distance (period) and amplitude for fiber strain
        period_fiberstrain = mean(diff(time(locs_fiberstrain)));
        amplitude_fiberstrain = mean(pks_fiberstrain);

        % Calculate the average peak-to-peak distance (period) and amplitude for plate strain
        period_platestrain = mean(diff(time(locs_platestrain)));
        amplitude_platestrain = mean(pks_platestrain);

        % Calculate the average peak-to-peak distance (period) and amplitude for stress
        period_stress = mean(diff(time(locs_stress)));
        amplitude_stress = mean(pks_stress);

        % Display results
        disp(['Average Period for Fiber Strain: ', num2str(period_fiberstrain)]);
        disp(['Average Period for Plate Strain: ', num2str(period_platestrain)]);
        disp(['Average Period for Stress: ', num2str(period_stress)]);
        disp(['Average Amplitude for Fiber Strain: ', num2str(amplitude_fiberstrain)]);
        disp(['Average Amplitude for Plate Strain: ', num2str(amplitude_platestrain)]);
        disp(['Average Amplitude for Stress: ', num2str(amplitude_stress)]);

        % Determine whether to save the data or not
        answer = questdlg('Look Good?','Double Check','Yes','No','Yes');
        switch answer
            case 'Yes'

                FitData.Fiber.Pktime = time(locs_fiberstrain) ;
                FitData.Fiber.Pk = pks_fiberstrain ;
                FitData.Fiber.Trtime = time(tlocs_fiberstrain) ;
                FitData.Fiber.Tr = trs_fiberstrain ;
                FitData.Fiber.Period = period_fiberstrain ;

                FitData.Plate.Pktime = time(locs_platestrain) ;
                FitData.Plate.Pk= pks_platestrain ;                
                FitData.Plate.Trtime = time(tlocs_platestrain) ;
                FitData.Plate.Tr = trs_platestrain ;
                FitData.Plate.Period = period_platestrain ;

                FitData.Stress.Pktime = time(locs_stress) ;
                FitData.Stress.Pk = pks_stress ;
                FitData.Stress.Trtime = time(tlocs_stress) ;
                FitData.Stress.Tr = trs_stress ;
                FitData.Stress.Period = period_stress ;

                savepath = fullfile(loadpath, "Fit Data.mat") ;
                save(savepath, "FitData") ;

                close all ;

                Check = 1 ;

            case 'No'
    
                definput = { char(string(PkDistance)), char(string(PkMult))} ; 
                quest = inputdlg({"Peak Distance", "Peak Multiplier"}, "", [1 50], definput) ;
                PkDistance = double(string(quest{1})) ; 
                PkMult = double(string(quest{2})) ; 

                close all ;

        end
    end



end
