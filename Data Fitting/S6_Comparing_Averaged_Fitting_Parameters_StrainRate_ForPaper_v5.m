clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiment Fits - v2.mat') ;
load('Average Stretch Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look for Write Speed
SRCompColIdx = 1:size(Data,2)-1 ;
SRCompCol = size(Data,2) ;
[StrainRateComps, ~, SRCidx] = unique(Data(:,SRCompColIdx), 'rows');

i = 1 ;
for n = 1:size(StrainRateComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SRCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,SRCompColIdx) ;
        Variables = Data(matchingRows, SRCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,12) ;
        YieldData = AveragedStretchExps(matchingRows,13) ;
        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s", ...
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

        CompDataTable{i,1} = Details ;
        CompDataTable{i,2} = Variables ;
        CompDataTable{i,3} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear Modmeans Modstddevs Lammeans Lamstddevs Yieldmeans YieldStds ;

    end
end

path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 3 - Tensile Testing Methods & Analysis" ; 

for n = 7 %2:size(CompDataTable)

    Mods = ModData(n,:) ;
    E1 = [] ;
    E2 = [] ;
    E3 = [] ;

    Lams = LamData(n,:) ;
    Lam1 = [] ;
    Lam2 = [] ;

    Yield = YSOut(n,:) ;
    YS = [] ;

    TickLabels = CompDataTable{n,2} + " \mum/s" ;


    for nn = 1:size(Mods,2)

        if ~isempty(Mods{1,nn})
            Moduli = Mods{1,nn} ;

            Mods1 = Moduli(:,1) ;
            Mods2 = Moduli(:,2)./Mods1 ;
            Mods3 = Moduli(:,3)./Mods1 ;

            Mods1Cell{1,nn} = Mods1 ;
            Mods2Cell{1,nn} = Mods2 ;
            Mods3Cell{1,nn} = Mods3 ;

            Lambda = Lams{1,nn} ;

            Lam1 = Lambda(:,1) ;
            Lam2 = Lambda(:,2) ;

            Lam1Cell{1,nn} = Lam1 ;
            Lam2Cell{1,nn} = Lam2 ;

            YieldStress = Yield{1,nn} ;

            YS = YieldStress(:,2) ;
            YStrain = YieldStress(:,1) ;
            YSCell{1,nn} = YS ;
            YStrainCell{1,nn} = YStrain ;
        end

    end

    % Create the plot
    fig1 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    %xlim([0.5 3.5]) ;
    ylim([45 85]) ;
    %yticks(round(linspace(yLimits(1),yLimits(2),5))) ;
    yticks(linspace(45, 85, 5)) ;
    xticklabels(TickLabels);
    ylabel('Stress (MPa)');
    set(gca, 'FontSize', 18) ;
    title("\sigma_y")
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName1 = 'SR_YS_v3';
    filename1 = fullfile(path,fileName1);  % Set your desired file name
    print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig2 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods1Cell) ;
    ylim([1000 2000]) ;
    yticks(linspace(1000,2000,5)) ;
    xticklabels(TickLabels);
    ylabel('Moduli (MPa)');
    set(gca, 'FontSize', 18) ;
    title("E_1") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName2 = 'SR_YM_v3';
    filename2 = fullfile(path,fileName2);  % Set your desired file name
    print(filename2, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig3 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods2Cell) ;
    ylim([0.2 0.6]) ;
    yticks(linspace(0.2, 0.6, 5)) ;
    xticklabels(TickLabels);
    ylabel('Moduli Coef.');
    set(gca, 'FontSize', 18) ;
    title("E_2/E_1") ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName3 = 'SR_2M_v3';
    filename3 = fullfile(path,fileName3);  % Set your desired file name
    print(filename3, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig4 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(Mods3Cell) ;
    %xlim([0.5 3.5]) ;
    yLimits = ylim ;
    ylim([0.4 1.4])
    yticks(linspace(0.4,1.4,5)) ;
    xticklabels(TickLabels);
    set(gca, 'FontSize', 18) ;
    title("E_3/E_1") ;
    ylabel('Moduli Coef.');
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName4 = 'SR_3M_v3';
    filename4 = fullfile(path,fileName4);  % Set your desired file name
    print(filename4, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    %sgtitle("Moduli Values",'FontSize', 15, 'FontWeight', 'bold');


    fig5 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    %subplot(1, 2, 1) ;
    customBoxPlot_noStats_ForPaper_v8(Lam1Cell) ;
    %xlim([0.5 3.5]) ;
    ylim([0.1 0.3]) ;
    yticks(linspace(0.1,0.3,5)) ;
    %yticks(round(linspace(yLimits(1),yLimits(2),6),2)) ;
    xticklabels(TickLabels);
    ylabel('Strain Coef.');
    %title('Strain Coefficient');
    set(gca, 'FontSize', 18) ;
    title("\lambda_1")
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName5 = 'SR_SC1_v3';
    filename5 = fullfile(path,fileName5);  % Set your desired file name
    print(filename5, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    %

    fig6 = figure('units', 'inches', 'Position', [ 13.5, 5, 3, 3 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(Lam2Cell) ;
    %xlim([0.5 3.5]) ;
    ylim([0.6 1.2]) ;
    yticks(linspace(0.6, 1.2, 5)) ;
    xticklabels(TickLabels);
    set(gca, 'FontSize', 18) ;
    title("\lambda_2");
    ylabel('Strain Coef.');
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName6 = 'SR_SC2_v3';
    filename6 = fullfile(path,fileName6);  % Set your desired file name
    print(filename6, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

end
