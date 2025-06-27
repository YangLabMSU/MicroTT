clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look For Strain Rate
PowCompColIdx = [1, 3:size(Data,2)] ;
CompColumn = 2 ; 
[PowerComps, ~, PCidx] = unique(Data(:,PowCompColIdx), 'rows');
i = 1 ;
for n = 1:size(PowerComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (PCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,PowCompColIdx) ;
        Variables = (double(Data(matchingRows, CompColumn)).*50)/100 ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;         
        CompData = AveragedStretchExps(matchingRows,12) ;
        YieldData = AveragedStretchExps(matchingRows,13) ;
        Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
            FitParameters = CompData{nn,1} ;
            Yield = YieldData{nn,1} ;
            Mods = FitParameters(:, [1 2 4]) ;
            Lams = FitParameters(:, [3 5]) ;
            Yields = Yield(:,[1 2]) ;

            ModData{i,nn} = Mods ;
            LamData{i,nn} = Lams ;
            YSOut{i,nn} = Yields ;

        end

        [~, sort_index] = sort(Variables);
        SortIdx{i,1} = sort_index ; 

        CompDataTable{i,1} = Details ;
        CompDataTable{i,2} = Variables ;
        CompDataTable{i,3} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

    end
end

% Combine the first 3 rows
for n = 1:5
combinedModData{1,n} = [ ModData{1, n} ; ModData{2, n} ; ModData{3, n} ];
combinedModData{2,n} = [ ModData{4, n} ; ModData{5, n} ; ModData{6, n} ];


combinedLamData{1,n} = [ LamData{1, n} ; LamData{2, n} ; LamData{3, n} ];
combinedLamData{2,n} = [ LamData{4, n} ; LamData{5, n} ; LamData{6, n} ];


combinedYSData{1,n} = [ YSOut{1, n} ; YSOut{2, n} ; YSOut{3, n} ];
combinedYSData{2,n} = [ YSOut{4, n} ; YSOut{5, n} ; YSOut{6, n} ];
end

% combinedModData = { combinedModData1; combinedModData2 };
% combinedLamData = { combinedLamData1 ; combinedLamData2 };
% combinedYSData = { combinedYSData1; combinedYSData2 } ;

NewConstantParamsKeep(1,:) = ConstantParamsKeep(1,1:end-1) ; 
NewConstantParamsKeep(2,:) = ConstantParamsKeep(4,1:end-1) ; 

NewCompDataTable{1,2} = CompDataTable{1,2} ; 
NewCompDataTable{2,2} = CompDataTable{4,2} ; 

NewCompDataTable{1,3} = [ CompDataTable{1,3} ; CompDataTable{2,3} ; CompDataTable{3,3} ] ;  
NewCompDataTable{2,3} = [ CompDataTable{4,3} ; CompDataTable{5,3} ; CompDataTable{6,3} ] ;  

NewCompDataTable{1,1} = "IP-S, Speed: 50 mm/s, w x h: 1 x 2 um, S x H: 0.5 x 0.5 um, Style: Vertical" ; 
NewCompDataTable{2,1} = "IP-S, Speed: 55 mm/s, w x h: 1 x 2 um, S x H: 0.2 x 0.4 um, Style: Cross" ; 

NewSortIndex{1,1} = SortIdx{1,1} ; %[ SortIdx{1,1} SortIdx{2,1} SortIdx{3,1} ] ; 
NewSortIndex{2,1} = SortIdx{4,1} ; %[ SortIdx{4,1} SortIdx{5,1} SortIdx{6,1} ] ; 

clear SortIdx YSOut ModData LamData ConstantParamsKeep CompDataTable ; 

ModData = combinedModData ; 
LamData = combinedLamData ; 
YSOut = combinedYSData ; 
CompDataTable = NewCompDataTable ; 
ConstantParamsKeep = NewConstantParamsKeep ; 
SortIdx = NewSortIndex ; 

for n = 1 %:size(CompDataTable)

    Mods = [] ; 
    Lams = [] ; 
    Yield = [] ; 

    %[Variables, sort_index] = sort(Variables);
    Sort = SortIdx{n,1} ; 

    Mods = ModData(n,:) ;
    E1 = [] ;
    E2 = [] ;
    E3 = [] ;

    Lams = LamData(n,:) ;
    Lam1 = [] ;
    Lam2 = [] ;

    Yield = YSOut(n,:) ;
    YS = [] ;

    TickLabels = CompDataTable{n,2} ;
    TickLabels = TickLabels(Sort) ; 
    TickLabels2 = TickLabels + " mW" ; 

    for nn = 1:size(Mods,2)
      
        if ~isempty(Mods{1,nn})

            nnn = Sort(nn) ; 

            Moduli = Mods{1,nnn} ;

            Mods1 = Moduli(:,1) ;
            Mods2 = Moduli(:,2)./Mods1 ;
            Mods3 = Moduli(:,3)./Mods1 ;

            Mods1Cell{1,nn} = Mods1 ;
            Mods2Cell{1,nn} = Mods2 ;
            Mods3Cell{1,nn} = Mods3 ;

            Lambda = Lams{1,nnn} ;

            Lam1 = Lambda(:,1) ;
            Lam2 = Lambda(:,2) ;

            Lam1Cell{1,nn} = Lam1 ;
            Lam2Cell{1,nn} = Lam2 ;

            YieldStress = Yield{1,nnn} ;

            YS = YieldStress(:,2) ;
            YStrain = YieldStress(:,1) ;
            YSCell{1,nn} = YS ;
            YStrainCell{1,nn} = YStrain ;

        end

    end

    path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 4 - Writing Power Evaluation" ;
    LargePlotSize = [ 15, 5, 8*3, 3.25*3 ] ; 
    SmallPlotSize = [15, 5, 4*3, 3*3] ; 
    TitleFontSize = 18 ; 
    TextFontSize = 20 ; 

    % Create the plot
    fig1 = figure('units', 'centimeters', 'position', LargePlotSize); hold on;
    customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    ylim([30 90]) ;
    yticks(linspace(30, 90, 5)) ;
    xticklabels(TickLabels2);
    set(gca, 'FontSize', TextFontSize) ;
    ylabel('Stress (MPa)');
    %xlabel('Write Power (mW)'); 
    title("\sigma_y")
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName1 = 'Pow_YS_v2';
    filename1 = fullfile(path,fileName1);  % Set your desired file name
    print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig2 = figure('units', 'centimeters', 'position', LargePlotSize); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods1Cell) ;
    ylim([500 2000]) ;
    yticks(linspace(500,2000,4)) ;
    xticklabels(TickLabels2);
    ylabel('Moduli (MPa)');
    %xlabel('Power (mW)'); 
    set(gca, 'FontSize', TextFontSize) ;
    title("E_1") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName2 = 'Pow_YM_v2';
    filename2 = fullfile(path,fileName2);  % Set your desired file name
    print(filename2, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig3 = figure('units', 'centimeters', 'position', SmallPlotSize); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods2Cell) ;
    ylim([0.25 0.5]) ; 
    yticks(linspace(0.25, 0.5, 6)) ;
    xticklabels(TickLabels);
    xlabel('Power (mW)'); 
    ylabel('Moduli Coef.');
    set(gca, 'FontSize', TextFontSize) ;
    title("E_2/E_1") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName3 = 'Pow_2M_v2';
    filename3 = fullfile(path,fileName3);  % Set your desired file name
    print(filename3, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig4 = figure('units', 'centimeters', 'position', SmallPlotSize); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods3Cell) ;
    ylim([0.4 1.2]) ;
    yticks(linspace(0.4,1.2,5)) ;
    xticklabels(TickLabels);
    xlabel('Power (mW)'); 
    ylabel('Moduli Coef.');
    set(gca, 'FontSize', TextFontSize) ;
    title("E_3/E_1") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName4 = 'Pow_3M_v2';
    filename4 = fullfile(path,fileName4);  % Set your desired file name
    print(filename4, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig5 = figure('units', 'centimeters', 'position', SmallPlotSize); hold on;
    %subplot(1, 2, 1) ;
    customBoxPlot_noStats_ForPaper_v8(Lam1Cell) ;
    ylim([0.1 0.3]) ;
    yticks(linspace(0.1,0.3,5)) ;
    xticklabels(TickLabels);
    xlabel('Power (mW)'); 
    ylabel('Strain Coef.');
    %title('Strain Coefficient');
    set(gca, 'FontSize', TextFontSize) ;
    title("\lambda_1")
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName5 = 'Pow_SC1_v2';
    filename5 = fullfile(path,fileName5);  % Set your desired file name
    print(filename5, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig6 = figure('units', 'centimeters', 'position', SmallPlotSize); hold on;
    customBoxPlot_noStats_ForPaper_v8(Lam2Cell) ;
    ylim([0.6 1.2]) ;
    yticks(linspace(0.6, 1.2, 5)) ;
    ylabel('Strain Coefficient');
    xticklabels(TickLabels);
    xlabel('Power (mW)'); 
    set(gca, 'FontSize', TextFontSize) ;
    title("\lambda_2");
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName6 = 'Pow_SC2_v2';
    filename6 = fullfile(path,fileName6);  % Set your desired file name
    print(filename6, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

end
