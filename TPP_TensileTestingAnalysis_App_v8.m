function TPP_TensileTestingAnalysis_App_v8
    function LoadVideo(hObject,handles,eventdata)

        [Video, Parameters] = TPP_TensileTesting_LoadVideo_and_Parameters() ; % Load in Video, and Input Experimental Parameters
        Grids = TPP_TensileTesting_GridGeneration(Video, Parameters.ResolutionMultiplier) ;

        %Exporting and Saving Data (VD, FolderName, F2S, Grid Details)
        path = fullfile(Video.Path,Parameters.FolderName);
        mkdir(path);
        VGD = fullfile(path,'Video and Parameters') ;    %Save File for Vid and Grid Data (VGD)
        GridPath = fullfile(path,'Grid Data') ;
        save(VGD,'Video','Parameters');
        save(GridPath, 'Grids') ;

        AQstorage = [Parameters.FolderName, path, '1'];

        AQ = get(AnalysisQueue,'String');

        if isempty(AQ) == 1

            set(AnalysisQueue,'String', [Parameters.FolderName]) ;
            set(AnalysisQueue,'Value',1);
            setappdata(f, 'AQdata' , AQstorage) ;

        else

            AQlist = [ AQ ; Parameters.FolderName ] ;
            set(AnalysisQueue,'String',AQlist);
            AQdata = getappdata(f,'AQdata') ;
            AQstorage = [ AQdata ; AQstorage ] ;
            setappdata(f, 'AQdata' , AQstorage);

        end
    end

    function LoadGridFolder(hObject,handles,eventdata)

        %Select Video For Analysis ( VD, Frames )
        [ ~ , path ] = uigetfile('*.mat','Select Video and Parameters File from folder') ; %Select an MP4 file to convert to video
        
        % Check if the user canceled the operation
        if path == 0
            disp('Operation canceled by user.');
            return;
        end

        VGD = fullfile(path,'Video and Parameters') ; %Save File for Vid and Grid Data (VGD)
        dummy = strsplit(path,'\');
        FolderName =  string(dummy(end-1));
        AQstorage = [FolderName, string(path), '2'];
        AQ = get(AnalysisQueue,'String');

        X = ismatrix(VGD);

        if X == 1

            if isempty(AQ) == 1
                set(AnalysisQueue,'String', FolderName) ;
                set(AnalysisQueue,'Value',1);
                setappdata(f, 'AQdata' , AQstorage) ;
            else
                AQlist = [ AQ ; FolderName ] ;
                set(AnalysisQueue,'String',AQlist);
                AQdata = getappdata(f,'AQdata') ;
                AQstorage = [ AQdata ; AQstorage ] ;
                setappdata(f, 'AQdata' , AQstorage);
            end

        else

            msgbox('No VGD File','Cannot Process Folder');

        end

    end

    function LoadGridFolderList(hObject, handles, eventdata)

        %Select Video For Analysis ( VD, Frames )
        DirectoryList = DirectoryListGenerator() ;

        for n = 1:1:length(DirectoryList)

            VGD = fullfile(DirectoryList(n,1),'Video and Parameters.mat') ; %Save File for Vid and Grid Data (VGD)
            dummy = strsplit(VGD,'\');
            FolderName =  string(dummy(end-1));
            AQstorage = [FolderName, DirectoryList(n,1), '2'];
            AQ = get(AnalysisQueue,'String');

            X = ismatrix(VGD);

            if X == 1

                if isempty(AQ) == 1
                    set(AnalysisQueue,'String', FolderName) ;
                    set(AnalysisQueue,'Value',1);
                    setappdata(f, 'AQdata' , AQstorage) ;
                else
                    AQlist = [ AQ ; FolderName ] ;
                    set(AnalysisQueue,'String',AQlist);
                    AQdata = getappdata(f,'AQdata') ;
                    AQstorage = [ AQdata ; AQstorage ] ;
                    setappdata(f, 'AQdata' , AQstorage);
                end

            else

                msgbox('No VGD File','Cannot Process Folder');

            end


        end



    end

    function AnalyzeSelected(hObject,handles,eventdata)

        selected = get(AnalysisQueue,'Value') ;

        AQdata = getappdata(f,'AQdata');
        path = AQdata(selected,2);

        DIC_Analysis(path) ;

        AQlist = get(AnalysisQueue,'String');
        AQlist(selected,:) = [] ;
        set(AnalysisQueue,'String',AQlist) ;
        AQdata(selected,:) = [] ;
        setappdata(f,'AQdata',AQdata);

    end

    function AnalyzeQueue(hObject,handles,eventdata)

        Queue = get(AnalysisQueue,'String') ;
        [final,~] = size(Queue) ;

        for selected = 1:1:final

            AQdata = getappdata(f,'AQdata');
            path = AQdata(1,2);

            DIC_Analysis(path) ;

            AQlist = get(AnalysisQueue,'String');
            AQlist(1,:) = [] ;
            set(AnalysisQueue,'String',AQlist) ;
            AQdata(1,:) = [] ;
            setappdata(f,'AQdata',AQdata);

        end
    end

    function PlottheData(hObject,handles,eventdata)

        PlotData_base ;

    end

    function ExportData(hObject,handles,eventdata)

        ExportData_base ;

    end

%Create Figure Window
f = figure ;
f.Visible = 'off' ;
f.Units = 'Normalized' ;
f.Position = [ .5 .5 .3 .5 ] ;
movegui(f,'center');
f.Color = 'White' ;
f.Name = 'Stretch Analyzer' ;
f.ToolBar = 'none' ;

%Figure Title
TitleLabel = uicontrol(f,'Style','text');
TitleLabel.Units = 'Normalized';
TitleLabel.Position = [ .125 .92 .75 .07 ] ;
TitleLabel.FontUnits= 'Normalized' ;
TitleLabel.BackgroundColor = 'w' ;
TitleLabel.FontSize = .65 ;
TitleLabel.String = 'Tensile Stretch Analyzer' ;
TitleLabel.FontWeight = 'bold' ;

%Credit
CreditLabel = uicontrol(f,'Style','text');
CreditLabel.Units = 'Normalized' ;
CreditLabel.Position = [ .375 .91 .25 .02 ] ;
CreditLabel.FontUnits = 'Normalized' ;
CreditLabel.BackgroundColor = 'w' ;
CreditLabel.FontSize = .7 ;
CreditLabel.String = 'Created By: Grayson Minnick' ;

%Import Video (IV) Label (*.mp4 or *.avi)
ImportVideoLabel = uicontrol(f,'Style','text');
ImportVideoLabel.Units = 'Normalized' ;
ImportVideoLabel.Position = [ .15 .85 .7 .05 ] ;
ImportVideoLabel.FontUnits = 'Normalized' ;
ImportVideoLabel.BackgroundColor = 'w' ;
ImportVideoLabel.FontSize = .8 ;
ImportVideoLabel.String = 'Import Video File (*.mp4 or *.avi)' ;
ImportVideoLabel.FontWeight = 'Bold' ;

%Load Movie Button LoadMovieButton
LoadVideoButton = uicontrol(f,'Style','pushbutton');
LoadVideoButton.Units = 'Normalized' ;
LoadVideoButton.Position = [ .4 .78 .2 .05 ] ;
LoadVideoButton.String = 'Load Video' ;
LoadVideoButton.Callback = @LoadVideo ;

%Load Image Folder LoadImageFolderButton
LoadImageFolderButton = uicontrol(f,'Style','pushbutton');
LoadImageFolderButton.Units = 'Normalized' ;
LoadImageFolderButton.Position = [ .4 .71 .2 .05 ] ;
LoadImageFolderButton.String = 'Load Grid Folder' ;
LoadImageFolderButton.Callback = @LoadGridFolder ;

%Analysis Label
AnalysisLabel = uicontrol(f,'Style','text');
AnalysisLabel.Units = 'Normalized' ;
AnalysisLabel.Position = [ .2 .64 .6 .05 ] ;
AnalysisLabel.FontUnits = 'Normalized' ;
AnalysisLabel.BackgroundColor = 'w' ;
AnalysisLabel.FontSize = .8 ;
AnalysisLabel.String = 'Displacement Analysis' ;
AnalysisLabel.FontWeight = 'Bold' ;

%Analysis Queue
AnalysisQueue = uicontrol(f,'Style','listbox');
AnalysisQueue.Units = 'Normalized';
AnalysisQueue.Position = [ .4 .48 .2 .15 ] ;

%Analyze Selected Button
AnalyzeSelectedButton = uicontrol(f,'Style','pushbutton');
AnalyzeSelectedButton.Units = 'Normalized' ;
AnalyzeSelectedButton.Position = [ .4 .41 .2 .05 ] ;
AnalyzeSelectedButton.String = 'Analyze Selected' ;
AnalyzeSelectedButton.Callback = @AnalyzeSelected ;

%Analyze Queue Button AnalyzeQueueButton
AnalyzeQueueButton = uicontrol(f,'Style','pushbutton');
AnalyzeQueueButton.Units = 'Normalized' ;
AnalyzeQueueButton.Position = [ .4 .34 .2 .05 ] ;
AnalyzeQueueButton.String = 'Analyze Queue' ;
AnalyzeQueueButton.Callback = @AnalyzeQueue;

%Plot Data Label
PlottingLabel = uicontrol(f,'Style','text');
PlottingLabel.Units = 'Normalized' ;
PlottingLabel.Position = [ .35 .27 .3 .05 ] ;
PlottingLabel.FontUnits = 'Normalized' ;
PlottingLabel.BackgroundColor = 'w' ;
PlottingLabel.FontSize = .8  ;
PlottingLabel.String = 'Plotting' ;
PlottingLabel.FontWeight = 'bold' ;

%Plot Data Button
PlotSelectedButton = uicontrol(f,'Style','pushbutton') ;
PlotSelectedButton.Units = 'Normalized' ;
PlotSelectedButton.Position = [ .4 .20 .2 .05 ] ;
PlotSelectedButton.String = 'Plot Data' ;
PlotSelectedButton.Callback = @LoadGridFolderList ;

%Export Data to Excel Label
ExportDataLabel = uicontrol(f,'Style','text');
ExportDataLabel.Units = 'Normalized' ;
ExportDataLabel.Position = [ .25 .13 .5 .05 ] ;
ExportDataLabel.FontUnits = 'Normalized' ;
ExportDataLabel.BackgroundColor = 'w' ;
ExportDataLabel.FontSize = .8  ;
ExportDataLabel.String = 'Export Data to Excel' ;
ExportDataLabel.FontWeight = 'bold' ;

%Export Data to Excel Button
PlotSelectedButton = uicontrol(f,'Style','pushbutton') ;
PlotSelectedButton.Units = 'Normalized' ;
PlotSelectedButton.Position = [ .4 .06 .2 .05 ] ;
PlotSelectedButton.String = 'Export Data' ;
PlotSelectedButton.Callback = @ExportData ;

f.Visible = 'on' ;                  %Turn Figure Window on
end