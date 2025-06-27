clear ; clc ; close ;

% Use the Experiment Table to Plot the Experiments
%load('All Experiments Table.mat') ;
%load('All Experiments Table Sub 6-14.mat')
%load('All IP-S Fatigue Experiment Table.mat') ; 
load('All IP-S Sub 6-5-24 Table.mat') ; 

%%

for n = [25 27] %1:size(AllExperimentTable,1)

    if double(AllExperimentTable(n,20)) == 0

        FractureCheck = FractureCheckFunction(AllExperimentTable(n,22)) ;
        SlipCheck = SlipCheckFunction(AllExperimentTable(n,22)) ;

        if FractureCheck == "No Fracture" && SlipCheck == "No Slip"

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

            StretchIdx = (CritPts(1,2)-1:1:CritPts(2,2)+1)' ;
            HoldIdx = (CritPts(2,2)+1:1:CritPts(3,2)) ;

            plot(ProcessedData.PlateStrain(StretchIdx), ProcessedData.Stress(StretchIdx), 'linewidth', 3) ; hold on ;
            plot(ProcessedData.PlateStrain(HoldIdx), ProcessedData.Stress(HoldIdx), 'linewidth', 3) ;

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

    end

    hold off ;

    %
end

