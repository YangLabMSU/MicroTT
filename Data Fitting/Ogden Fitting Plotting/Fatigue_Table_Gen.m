clear ; clc ; close all ; 

load('All_IPS_LargeStrain_Data_TrueOgden_Fatigue.mat') ; 
All_IPS_Data_Ogden_Fatigue = All_IPS_Data_Ogden ; 
All_IPS_Data_Ogden_Fatigue_Table = [] ; 

for n = 1:size(All_IPS_Data_Ogden,1)

    TableData = All_IPS_Data_Ogden{n,1} ; 
    All_IPS_Data_Ogden_Fatigue_Table = [ All_IPS_Data_Ogden_Fatigue_Table ; TableData ] ; 

end

save("All_IPS_LargeStrain_Data_TrueOgden_Fatigue.mat", "All_IPS_Data_Ogden_Fatigue", "All_IPS_Data_Ogden_Fatigue_Table") ; 

