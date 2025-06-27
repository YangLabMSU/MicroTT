function DataDirectory = LoadRawDataExperimentDirectory_Folder(selectedFolder) 

%selectedFolder = uigetdir('Select a folder Analyzed Experiment Folders');

% Check if the user canceled the operation
% if selectedFolder == 0
%     disp('Operation canceled by user.');
%     return;
% end

% % Find All Videos in the Folder, List all files in the selected folder
files = dir(fullfile(selectedFolder));
i = 1 ; 
for n = 1:1:length(files) 

    CheckDir = files(n).isdir ; 

    if CheckDir == 1

        RawDataCheck = isfile(fullfile(files(n).folder, files(n).name, 'Raw Data.mat')) ; 

        if RawDataCheck == 1 

            DataDirectory(i,1) = string(fullfile(files(n).folder, files(n).name)) ; 
            FileNumber(i,1) = double(string(files(n).name)) ; 
            i = i + 1 ; 
        end

    end

end

[~,I] = sort(FileNumber) ;
DataDirectory = DataDirectory(I,1) ; 

end
