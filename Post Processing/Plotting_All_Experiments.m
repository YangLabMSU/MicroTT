clear ; clc ; close ;

% Use the Experiment Table to Plot the Experiments
load('All Experiments Table.mat') ;

for n = 2:size(AllExperimentTable,1)

    if double(AllExperimentTable(n,20)) == 0 

        FractureCheck = FractureCheckFunction(AllExperimentTable(n,20)) ; 

        if FractureCheck == "No "

        path = AllExperimentTable(n,27) ;
        load(path) ;

        displacement = ProcessedData.TopDisplacement ;
        velocity = diff(ProcessedData.TopDisplacement) ;
        acceleration = diff(diff(ProcessedData.TopDisplacement)) ;
        PeakLim = max(acceleration)*0.5 ;
        [pks1, locs1] = findpeaks(smooth(smooth(acceleration)), 'MinPeakHeight', PeakLim, 'NPeaks', 2) ;
        [pks2, locs2] = findpeaks(-smooth(smooth(acceleration)), 'MinPeakHeight', PeakLim, 'NPeaks', 2) ;
        pks = [ pks1 ; -pks2 ] ;

        if size(pks,1) < 4
            [pks1, locs1] = findpeaks(smooth(smooth(acceleration)), 'NPeaks', 2, 'MinPeakDistance', 50) ;
            [pks2, locs2] = findpeaks(-smooth(smooth(acceleration)), 'NPeaks', 2, 'MinPeakDistance', 50) ;
            pks = [ pks1 ; -pks2 ] ;
        end

        locs = [ locs1 ; locs2 ] ;

        [~,Idx] = sort(locs) ;
        CritPts = [ pks(Idx), locs(Idx) ] ;

        StretchIdx = (CritPts(1,2)-3:1:CritPts(2,2)+3)' ;
        HoldIdx = (CritPts(2,2)+3:1:CritPts(3,2)) ;

        plot(ProcessedData.PlateStrain(StretchIdx), ProcessedData.Stress(StretchIdx)) ; hold on ;
        plot(ProcessedData.PlateStrain(HoldIdx), ProcessedData.Stress(HoldIdx)) ;

        choice = questdlg('Does the plot look good?', ...
            'Plot Evaluation', ...
            'Yes', 'No, Input Pts', 'No, Skip', 'Yes');

        % Handle the user's choice
        switch choice
            case 'Yes'

                ProcessedData.StretchIdx = [StretchIdx(1), StretchIdx(end)];
                ProcessedData.HoldIdx = [HoldIdx(1), HoldIdx(end)] ;
                save(path, "ProcessedData") ;

            case 'No, Input Pts'

                hold off ;
                plot(ProcessedData.TopDisplacement) ; hold on ;
                [XLim, ~] = ginput(2) ;
                xlim([0 XLim(1)+10]) ;
                [StartIdx,~] = ginput(2) ;
                xlim([XLim(2)-10 size(ProcessedData.TopDisplacement,1)]) ;
                [EndIdx, ~] = ginput(1) ;
                StretchIdx = round(StartIdx(1)):1:round(StartIdx(2)) ;
                HoldIdx = round(StartIdx(2)):1:round(EndIdx) ;
                hold off ;

                plot(ProcessedData.PlateStrain(StretchIdx), ProcessedData.Stress(StretchIdx)) ; hold on ;
                plot(ProcessedData.PlateStrain(HoldIdx), ProcessedData.Stress(HoldIdx)) ;
                hold on ;

                choice2 = questdlg('Does the plot look good?', ...
                    'Plot Evaluation', ...
                    'Yes', 'No', 'Yes');

                switch choice2
                    case 'Yes'

                        ProcessedData.StretchIdx = [ StartIdx(1) StartIdx(2) ] ;
                        ProcessedData.HoldIdx = [ StartIdx(2) EndIdx ] ; 
                        save(path, "ProcessedData") ;

                    case 'No'

                        disp('Data is fucked') ;

                end

            case 'No, Skip'

                disp('Data is fucked') ;

        end

    end

    hold off ;

    %
end

% displacement = ProcessedData.TopDisplacement ;
% velocity = diff(ProcessedData.TopDisplacement) ;
% acceleration = diff(diff(ProcessedData.TopDisplacement)) ;
%
% subplot(3,1,1) ;
% plot(ProcessedData.Time, displacement) ;
% subplot(3,1,2) ;
% plot(ProcessedData.Time(1:end-1), velocity) ;
% subplot(3,1,3) ;
% plot(ProcessedData.Time(1:end-2), smooth(smooth(acceleration))) ; hold on ;
% PeakLim = max(acceleration)*0.75 ;
% [pks1, locs1] = findpeaks(smooth(smooth(acceleration)), 'MinPeakHeight', PeakLim, 'NPeaks', 2) ;
% [pks2, locs2] = findpeaks(-smooth(smooth(acceleration)), 'MinPeakHeight', PeakLim, 'NPeaks', 2) ;
% pks = [ pks1 ; -pks2 ] ;
% locs = [ locs1 ; locs2 ] ;
% plot(ProcessedData.Time(locs), pks, 'rx', 'MarkerFaceColor', 'r'); % Mark peaks with red triangles
