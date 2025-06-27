clear ; clc ; close all ;

% Generating IP-S Power Table without a care for Strain Rate
clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16] ;

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

    ConstantParams = Data(matchingRows,PowCompColIdx) ;
    Variables = (double(Data(matchingRows, CompColumn)).*50)/100 ;
    SEMAreas = AveragedStretchExps(matchingRows,1) ;
    CompData = AveragedStretchExps(matchingRows,12) ;
    YieldData = AveragedStretchExps(matchingRows,13) ;
    Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s", ...
        ConstantParams(1,:)) ;

    for nn = 1:size(CompData,1)

        SEMArea(nn,1) = SEMAreas{nn,1}(1,15) ;
        FitParameters = CompData{nn,1} ;
        Yield = YieldData{nn,1} ;
        Mods = FitParameters(:, [1 2 4]) ;
        Lams = FitParameters(:, [3 5]) ;
        Yields = Yield(:,[1 2]) ;

        ModData1{i,nn} = Mods ;
        LamData1{i,nn} = Lams ;
        YSOut1{i,nn} = Yields ;

    end

    [~, sort_index] = sort(Variables);
    SortIdx{i,1} = sort_index ;

    CompDataTable1{i,1} = Details ;
    CompDataTable1{i,2} = Variables ;
    CompDataTable1{i,3} = SEMArea ;

    ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

    i = i + 1 ;

    clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

end

ToKeep = 11:16 ;
ConstantParamsKeep = ConstantParamsKeep(ToKeep,:) ;

for n = 1:length(ToKeep)
    CompDataTable{n,1} = CompDataTable1{ToKeep(n), 1};
    CompDataTable{n,2} = CompDataTable1{ToKeep(n), 2};
    CompDataTable{n,2} = CompDataTable1{ToKeep(n), 3};

    ModData{n,1} = ModData1{ToKeep(n),:} ;
    LamData{n,1} = LamData1{ToKeep(n),:} ;
    YSOut{n,1} = YSOut1{ToKeep(n),:} ;
end

Combine = [ 1 2 3 ; 4 5 6 ] ; 

for n = 1:size(Combine,1) 

    ModulusData = [] ; 
    LamdaData = [] ; 
    YieldData = [] ; 

    CombineIdx = Combine(n,:) ; 
    for nn = 1:size(CombineIdx,2) 

        Mod  = ModData{CombineIdx(nn)} ; 

        ModulusData = [ ModulusData ; ModData{CombineIdx(nn)}] ;
        LamdaData = [ LamdaData ; LamData{CombineIdx(nn)}] ; 
        YieldData = [ YieldData ; YSOut{CombineIdx(nn)}] ; 

    end

    ModDataOut{n,1} = ModulusData ;
    LamdaDataOut{n,1} = LamdaData ; 
    YieldDataOut{n,1} = YieldData ; 

end

ConstantParamsKeep = ConstantParamsKeep([1,4],1:end-1) ;

for n = 1:size(ModDataOut,1) 

    YSCell = YieldDataOut{n}(:,2) ; 
    YSStrainCell = YieldDataOut{n}(:,1) ; 
    Mods1Cell = ModDataOut{n}(:,1) ; 
    Mods2Cell = ModDataOut{n}(:,2) ;
    Mods3Cell = ModDataOut{n}(:,3) ;
    Lam1Cell = LamdaDataOut{n}(:,1) ;
    Lam2Cell = LamdaDataOut{n}(:,2) ;

    fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 3]); hold on;
    customBoxPlot_withStats_v7(YSCell) ;
    % customBoxPlot_withStats_v6(YSCell) ;
    % customBoxPlot_noStats_v8(YSCell) ;
    % customBoxPlot_withStats_v9(YSCell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    ylabel('Stress (MPa)', 'FontSize', 14);
    title('Yield Stress', 'FontSize', 15, 'FontWeight', 'bold');
    set(gca, 'FontSize', 14) ;
    title("Yield Stress, \sigma_y", 'FontSize',12)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % fig2 = figure('units', 'inches', 'Position', [ 13.5, 0.5, 12, 5 ]); hold on;
    % subplot(1,3,1) ;
    fig2 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 3]); hold on;
    customBoxPlot_withStats_v7(Mods1Cell) ;
    %customBoxPlot_withStats_v6(Mods1Cell) ;
    %customBoxPlot_noStats_v8(Mods1Cell) ;
    %customBoxPlot_withStats_v9(Mods1Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    ylabel('Moduli (MPa)', 'FontSize', 14);
    set(gca, 'FontSize', 14) ;
    title("Youngs Modulus, 1st Modulus E_1", 'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % subplot(1,3,2) ;
    fig3 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 3]); hold on;
    customBoxPlot_withStats_v7(Mods2Cell) ;
    % customBoxPlot_withStats_v6(Mods2Cell) ;
    % customBoxPlot_noStats_v8(Mods2Cell) ;
    %customBoxPlot_withStats_v9(Mods2Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    % ylabel('Moduli (MPa)', 'FontSize', 14);
    % title('Moduli');
    set(gca, 'FontSize', 14) ;
    title("2nd Modulus E_2", 'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % subplot(1,3,3) ;
    fig4 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 3 ]); hold on;
    customBoxPlot_withStats_v7(Mods3Cell) ;
    %customBoxPlot_withStats_v6(Mods3Cell) ;
    %customBoxPlot_noStats_v8(Mods3Cell) ;
    %customBoxPlot_withStats_v9(Mods3Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    set(gca, 'FontSize', 14) ;
    title("3rd Modulus E_3", 'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    %sgtitle("Moduli Values",'FontSize', 15, 'FontWeight', 'bold');

    % 
    % fig3 = figure('units', 'inches', 'Position', [ 17.5, 5, 8, 5 ]); hold on;
    % subplot(1, 2, 1) ;
    fig5 = figure('units', 'inches', 'Position', [ 13.5, 5, 6, 3 ]); hold on;
    customBoxPlot_withStats_v7(Lam1Cell) ;
    %customBoxPlot_withStats_v6(Lam1Cell) ;
    %customBoxPlot_noStats_v8(Lam1Cell) ;
    %customBoxPlot_withStats_v9(Lam1Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
    xticklabels(TickLabels);
    ylabel('Strain Coefficient', 'FontSize', 14);
    %title('Strain Coefficient');
    set(gca, 'FontSize', 14) ;
    title("Strain Coefficient 1, \lambda_1", 'FontSize',12)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % subplot(1, 2, 2) ;
    fig6 = figure('units', 'inches', 'Position', [ 13.5, 5, 9, 5 ]); hold on;
    customBoxPlot_withStats_v7(Lam2Cell) ;
    %customBoxPlot_withStats_v6(Lam2Cell) ;
    %customBoxPlot_noStats_v8(Lam2Cell) ;
    %customBoxPlot_withStats_v9(Lam2Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
    xticklabels(TickLabels);
    set(gca, 'FontSize', 14) ;
    title("Strain Coefficient 2, \lambda_2", 'FontSize',12)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    %sgtitle("Strain Coefficients", 'FontSize', 15, 'FontWeight', 'bold') ;

    % Define the directory where the figure will be saved
    newFolder = 'Dissertation - Write Power Comparisons All Rates' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    Details2 = sprintf("%s_Pow%s_WxH%sx%s_SxH%sx%s_%s", ...
        ConstantParamsKeep(n,:)) ;
    disp(Details2);

    fileName1 = Details2+'_YS_v4'+'.tiff';
    fileName2 = Details2+'_E1_v4'+'.tiff';
    fileName3 = Details2+'_E2_v4'+'.tiff';
    fileName4 = Details2+'_E3_v4'+'.tiff';
    fileName5 = Details2+'_Lam1_v4'+'.tiff';
    fileName6 = Details2+'_Lam2_v4'+'.tiff';
    path = cd ;
    fullFilePath1 = fullfile(path, newFolder, fileName1);
    fullFilePath2 = fullfile(path, newFolder, fileName2);
    fullFilePath3 = fullfile(path, newFolder, fileName3);
    fullFilePath4 = fullfile(path, newFolder, fileName4);
    fullFilePath5 = fullfile(path, newFolder, fileName5);
    fullFilePath6 = fullfile(path, newFolder, fileName6);

    % Save the figure as a JPEG file
    saveas(fig1, fullFilePath1, 'tiff');
    saveas(fig2, fullFilePath2, 'tiff');
    saveas(fig3, fullFilePath3, 'tiff');
    saveas(fig4, fullFilePath4, 'tiff');
    saveas(fig5, fullFilePath5, 'tiff');
    saveas(fig6, fullFilePath6, 'tiff');

    pause(1) ;
    hold off ;

    % close all ;

    clear YSCell YStrainCell Lam2Cell Lam1Cell Mods1Cell Mods2Cell Mods3Cell ;
    
end




