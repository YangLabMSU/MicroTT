function [DirectoryList] = DirectoryListGenerator() 

% Load in Folder Containing Videos
selectedFolder = uigetdir('Select a folder containing all Experimental Subfolders');

% Check if the user canceled the operation
if selectedFolder == 0
    disp('Operation canceled by user.');
    return;
end

% Find All Videos in the Folder, List all files in the selected folder
files = dir(selectedFolder);

i = 1 ; 
for n = 1:1:length(files)

    PathtoCheck = fullfile(files(n).folder, files(n).name ); 

    if isfolder(PathtoCheck) == 1
       
        File2Check = fullfile(PathtoCheck, "Video and Parameters.mat") ;

        if isfile(File2Check) == 1
            
            p2c = string(PathtoCheck) ; 

            DirectoryList(i,1) = p2c ;

            VideoNum = strsplit(DirectoryList(i,1), '\') ; 
            VideoNumber(i,1) = double(VideoNum(end)) ; 
            i = i + 1 ; 

        end

    end

end

[~,I] = sort(VideoNumber) ;
DirectoryList = DirectoryList(I,1) ; 

end