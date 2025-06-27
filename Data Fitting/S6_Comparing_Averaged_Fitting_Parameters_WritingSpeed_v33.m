clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiments Fits - Sub 6-14.mat') ;
load('Average Stretch Table - Sub 6-14.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look for Write Speed
SpdCompColIdx = [1:2, 4:size(Data,2)] ;
SpdCompCol = 3 ;
[SpdComps, ~, SCidx] = unique(Data(:,SpdCompColIdx), 'rows');

i = 1 ;
for n = 1:size(SpdComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,SpdCompColIdx) ;
        Variables = Data(matchingRows, SpdCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,8) ;
        Details = sprintf("%s, Power: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
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

        [~, sort_index] = sort(double(Variables));
        SortIdx{i,1} = sort_index ;

        CompDataTable{i,1} = Details ;
        CompDataTable{i,2} = Variables ;
        CompDataTable{i,3} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

    end
end

for n = 1:size(CompDataTable)

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

    TickLabels = CompDataTable{n,2} + " mm/s" ;
    TickLabels = TickLabels(Sort) ;

    for nn = 1:size(Mods,2)

        if ~isempty(Mods{1,nn})
            nnn = Sort(nn) ;

            Moduli = Mods{1,nnn} ;

            Mods1 = Moduli(:,1) ;
            Mods2 = Moduli(:,2) ;
            Mods3 = Moduli(:,3) ;

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

    % Create the plot
    %fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 5 ]); hold on;
    fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    % customBoxPlot_withStats_v7(YSCell) ;
    % customBoxPlot_withStats_v6(YSCell) ;
    % customBoxPlot_noStats_v8(YSCell) ;
    customBoxPlot_withStats_v9(YSCell) ;
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
    fig2 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    %customBoxPlot_withStats_v7(Mods1Cell) ;
    %customBoxPlot_withStats_v6(Mods1Cell) ;
    %customBoxPlot_noStats_v8(Mods1Cell) ;
    customBoxPlot_withStats_v9(Mods1Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)', 'FontSize', 14);
    set(gca, 'FontSize', 14) ;
    title("Youngs Modulus, 1st Modulus E_1", 'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % subplot(1,3,2) ;
    fig3 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    %customBoxPlot_withStats_v7(Mods2Cell) ;
    % customBoxPlot_withStats_v6(Mods2Cell) ;
    % customBoxPlot_noStats_v8(Mods2Cell) ;
    customBoxPlot_withStats_v9(Mods2Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+2,yLimits(2)-2,6))) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)', 'FontSize', 14);
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
    fig4 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    %customBoxPlot_withStats_v7(Mods3Cell) ;
    %customBoxPlot_withStats_v6(Mods3Cell) ;
    %customBoxPlot_noStats_v8(Mods3Cell) ;
    customBoxPlot_withStats_v9(Mods3Cell) ;
    %xlim([0.5 3.5]) ;
    ylabel('Modulus (MPa)', 'FontSize', 14);
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
    fig5 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    %customBoxPlot_withStats_v7(Lam1Cell) ;
    %customBoxPlot_withStats_v6(Lam1Cell) ;
    %customBoxPlot_noStats_v8(Lam1Cell) ;
    customBoxPlot_withStats_v9(Lam1Cell) ;
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
    fig6 = figure('units', 'inches', 'Position', [ 13.5, 5, 5, 4 ]); hold on;
    %customBoxPlot_withStats_v7(Lam2Cell) ;
    %customBoxPlot_withStats_v6(Lam2Cell) ;
    %customBoxPlot_noStats_v8(Lam2Cell) ;
    customBoxPlot_withStats_v9(Lam2Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+0.01,yLimits(2)-0.01,6),2)) ;
    xticklabels(TickLabels);
    ylabel('Strain Coefficient', 'FontSize', 14);
    set(gca, 'FontSize', 14) ;
    title("Strain Coefficient 2, \lambda_2", 'FontSize',12)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;
    %sgtitle("Strain Coefficients", 'FontSize', 15, 'FontWeight', 'bold') ;

    % % Define the directory where the figure will be saved
    % newFolder = 'Dissertation - Write Speed Comparisons - v3' ;
    % 
    % % Check if the folder exists, if not, create it
    % if ~exist(newFolder, 'dir')
    %     mkdir(newFolder);
    % end
    % 
    % % Define the full path to save the JPEG file
    % Details2 = sprintf("%s_Pow%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
    %     ConstantParamsKeep(n,:)) ;
    % disp(Details2);
    % 
    % fileName1 = Details2+'_YS_v5'+'.tiff';
    % fileName2 = Details2+'_E1_v5'+'.tiff';
    % fileName3 = Details2+'_E2_v5'+'.tiff';
    % fileName4 = Details2+'_E3_v5'+'.tiff';
    % fileName5 = Details2+'_Lam1_v5'+'.tiff';
    % fileName6 = Details2+'_Lam2_v5'+'.tiff';
    % path = cd ;
    % fullFilePath1 = fullfile(path, newFolder, fileName1);
    % fullFilePath2 = fullfile(path, newFolder, fileName2);
    % fullFilePath3 = fullfile(path, newFolder, fileName3);
    % fullFilePath4 = fullfile(path, newFolder, fileName4);
    % fullFilePath5 = fullfile(path, newFolder, fileName5);
    % fullFilePath6 = fullfile(path, newFolder, fileName6);
    % 
    % % Save the figure as a JPEG file
    % saveas(fig1, fullFilePath1, 'tiff');
    % saveas(fig2, fullFilePath2, 'tiff');
    % saveas(fig3, fullFilePath3, 'tiff');
    % saveas(fig4, fullFilePath4, 'tiff');
    % saveas(fig5, fullFilePath5, 'tiff');
    % saveas(fig6, fullFilePath6, 'tiff');
    % 
    pause(3) ;
    hold off ;

    close all ;

    clear YSCell YStrainCell Lam2Cell Lam1Cell Mods1Cell Mods2Cell Mods3Cell ;

end
