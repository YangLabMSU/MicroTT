clear ; clc ; close ;

% Plot Storage and Loss Moduli Data

% Generate Data Directory
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 9-05-23_TD 10-18-23" ;
DataDirectory1 = LoadRawDataExperimentDirectory_Folder(folderpath) ;
folderpath = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Cyclic Data - v3 - Analyzed\Substrate 10-27-23_TD 11-15-23" ;
DataDirectory2 = LoadRawDataExperimentDirectory_Folder(folderpath) ;
DataDirectory = [ DataDirectory1 ; DataDirectory2 ] ; 

i = 1;
for n = 1:size(DataDirectory)



end




