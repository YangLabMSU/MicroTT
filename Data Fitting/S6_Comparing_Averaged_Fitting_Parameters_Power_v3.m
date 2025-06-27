clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 ] ;

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
        Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s", ...
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

    TickLabels = CompDataTable{n,2} + " mW" ;
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
    fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 4, 3 ]); hold on;
    customBoxPlot_withStats_v6(YSCell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+1,yLimits(2)-1,6))) ;
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

    fig2 = figure('units', 'inches', 'Position', [ 13.5, 0.5, 12, 3 ]); hold on;
    subplot(1,3,1) ;
    customBoxPlot_withStats_v6(Mods1Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+1,yLimits(2)-1,6))) ;
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

    subplot(1,3,2) ;
    customBoxPlot_withStats_v6(Mods2Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+1,yLimits(2)-1,6))) ;
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

    subplot(1,3,3) ;
    customBoxPlot_withStats_v6(Mods3Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    yticks(round(linspace(yLimits(1)+1,yLimits(2)-1,6))) ;
    xticklabels(TickLabels);
    set(gca, 'FontSize', 14) ;
    title("3rd Modulus E_3", 'FontSize',12) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    sgtitle("Moduli Values",'FontSize', 15, 'FontWeight', 'bold');


    fig3 = figure('units', 'inches', 'Position', [ 17.5, 5, 8, 3 ]); hold on;
    subplot(1, 2, 1) ;
    customBoxPlot_withStats_v6(Lam1Cell) ;
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

    subplot(1, 2, 2) ;
    customBoxPlot_withStats_v6(Lam2Cell) ;
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
    sgtitle("Strain Coefficients", 'FontSize', 15, 'FontWeight', 'bold') ;

    % Define the directory where the figure will be saved
    newFolder = 'Dissertation - Power Comparisons - PowPt' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    Details2 = sprintf("%s_Spd%s_WxH%sx%s_SxH%sx%s_%s", ...
        ConstantParamsKeep(n,:)) ;

    disp(Details2);

    fileName1 = Details2+'_Fig1_v1'+'.tiff';
    fileName2 = Details2+'_Fig2_v1'+'.tiff';
    fileName3 = Details2+'_Fig3_v1'+'.tiff';
    path = cd ;
    fullFilePath1 = fullfile(path, newFolder, fileName1);
    fullFilePath2 = fullfile(path, newFolder, fileName2);
    fullFilePath3 = fullfile(path, newFolder, fileName3);

    % Save the figure as a JPEG file
    saveas(fig1, fullFilePath1, 'tiff');
    saveas(fig2, fullFilePath2, 'tiff');
    saveas(fig3, fullFilePath3, 'tiff');

    pause(1) ;
    hold off ;

    close all ;

    clear YSCell YStrainCell Lam2Cell Lam1Cell Mods1Cell Mods2Cell Mods3Cell ; 

end
