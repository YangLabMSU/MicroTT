clear ; clc ; close ;

% Update the Video Path Files in the Experiment Folders to Match the
% Directory

% Load in Folder(s) All Experiemntal Folders
SelectedFolder = uigetdir('Select a folder containing experiment folders and video files','');

% Check if the user canceled the operation
if SelectedFolder == 0
    disp('Operation canceled by user.');
    return;
end

AllExpFolders = dir(SelectedFolder) ;

i = 0 ;
for n = 1:1:size(AllExpFolders,1)

    if AllExpFolders(n).isdir == 1 && AllExpFolders(n).name ~= "." && AllExpFolders(n).name ~= ".."
        i = i + 1 ;
        ExperimentFolders(i,:) = AllExpFolders(n,:) ;
    end

end

for n = 1:1:size(ExperimentFolders,1)

    expfolder = fullfile(ExperimentFolders(n).folder, ExperimentFolders(n).name);
    filename = "Grid Data.mat" ;
    DataDirectory = TPPTT_DirectoryGenerator(expfolder, filename) ;

    for Experiments = 1:1:length(DataDirectory)

        ExperimentPath = DataDirectory(Experiments) ;
        VandPPath = fullfile(ExperimentPath,"Video and Parameters.mat") ;
        load(VandPPath) ;

        % Generate Correct Video Path
        OldVidPath = Parameters.VideoLoadPath ;
        OPVidNum = strsplit(OldVidPath,"\") ;
        OPVidNum = strsplit(OPVidNum(end),"_") ;
        OPVidName = OPVidNum(1) ;

        if size(OPVidNum, 2) > 1

            OPVidNum = strsplit(OPVidNum(2), ".") ;
            OPVidNum = double(OPVidNum(1)) ;

        else
            OPVidNum = 0 ;
        end

        % Get Video Number From Folder
        VidNum = strsplit(ExperimentPath, "\") ;
        VidNum = double(VidNum(end));

        % Compare The Video Numbers, Ensure they are correct and real
        if VidNum == OPVidNum

            disp("Folder and Video Match");

            if OPVidNum ~= 0 
                CorrVP = strcat(OPVidName, "_", sprintf('%03d',VidNum), ".mp4") ;
            else
                CorrVP = OPVidName ; 
            end

            % Update Path
            Parameters.Folder = expfolder ;
            Parameters.VideoLoadPath = fullfile(expfolder, CorrVP) ;
            Video = VideoReader(Parameters.VideoLoadPath) ;

            SavePath = fullfile(expfolder, string(VidNum), "Video and Parameters.mat") ;
            save(SavePath, "Video", "Parameters") ;


        else

            disp("Mismatch of Folder and Video Number!!") ;
            disp(ExperimentPath) ;

            % Check to see if a matching video exists

            CorrVP = strcat(OPVidName, "_", sprintf('%03d',VidNum), ".mp4") ;
            VidPath = fullfile(expfolder, CorrVP) ;
            VidPathCheck = isfile(VidPath) ;

            if VidPathCheck == 1

                disp("Video Found in Folder!") ;

                % Update Path
                Parameters.Folder = expfolder ;
                Parameters.VideoLoadPath = fullfile(expfolder, CorrVP) ;
                Video = VideoReader(Parameters.VideoLoadPath) ;

                SavePath = fullfile(expfolder, string(VidNum),"Video and Parameters.mat") ;
                save(SavePath, "Video", "Parameters") ;

            else

                disp("Video not Found in Folder!") ;

            end

        end

    end
end


