clear ; clc ; close ;

% Group and Average Data 
load('All_IPS_LargeStrain_Data_TrueOgden_v6.mat') ; % Load in data and Table
Table = All_IPS_Data_Table ; 
Data = All_IPS_Data_Ogden ;

for n = 1:size(AvgTable,1)

    Experiments = strsplit(AvgTable(n,4), ',') ;
    Experiments = double(Experiments) ;

    Material = AvgTable(n,1) ;
    Substrate = AvgTable(n,2) ;

    Parameters = [] ;
    YieldData = [] ; 

    for nn = 1:size(Experiments,2)

        matching_rows2 = (AllExpTable(:,1) == Material & AllExpTable(:,2) == Substrate...
            & double(AllExpTable(:,5)) == Experiments(nn)) ;
        [MRidx, ~] = find(matching_rows2 == 1, 1, 'first') ;

        if ~isempty(StretchExperimentData{MRidx, 5})

           paramData = StretchExperimentData{MRidx, 5};
            if size(paramData, 2) == 3

                Parameters(nn, 1:3) = paramData;
                Parameters(nn, 4:5) = strings(1, 2);  % Fill the remaining with empty strings
                YieldData(nn,:) = StretchExperimentData{MRidx, 7} ; 

            elseif size(paramData, 2) == 5

                Parameters(nn, :) = paramData;
                YieldData(nn,:) = StretchExperimentData{MRidx, 7} ; 

            end

        else

            Parameters(nn, :) = strings(1, 5);  % Assume 5 columns, fill with empty strings
            YieldData(nn,:) = strings(1, 2); 

        end

    end

    AvgExpData{n,1} = Parameters ;
    AveragedStretchExps{n,7} = Parameters ; 
    AveragedStretchExps{n,8} = YieldData ; 

end

%save('Average Stretch Experiments - Sub 6-5-24.mat', "AveragedStretchExps") ; 

