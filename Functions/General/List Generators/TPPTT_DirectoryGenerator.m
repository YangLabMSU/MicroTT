function [DataDirectory] = TPPTT_DirectoryGenerator(selectedFolder, filename)

files = dir(fullfile(selectedFolder));

i = 1 ; 
for n = 1:1:length(files) 

    CheckDir = files(n).isdir ; 

    if CheckDir == 1

        DataCheck = isfile(fullfile(files(n).folder, files(n).name, filename)) ; 

        if DataCheck == 1 

            DataDirectory(i,1) = string(fullfile(files(n).folder, files(n).name)) ; 
            FileNumber(i,1) = double(string(files(n).name)) ; 
            i = i + 1 ; 

        end

    end

end

[~,I] = sort(FileNumber) ;
DataDirectory = DataDirectory(I,1) ; 

end