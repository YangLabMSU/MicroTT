clear ; clc ; close ;

% Comparing Fitting Parameters of Similar Experiments
% load('Average Stretch Experiments Fits - Sub 6-14.mat') ; 
load('Average Stretch Experiments - Sub 6-5-24.mat') ;

% load('Average Stretch Table - Sub 6-14.mat') ;
load('Average Stretch IP-S - Sub 6-5-24 - Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Look for Write Speed
HatCompColIdx = [1:5, 8 9] ;
HatCompCol = [ 6 7 ] ;
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');

i = 1 ;
for n = 1:size(HatComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (HatCidx == n) ;

    if sum(matchingRows) > 1

        ConstantParams = Data(matchingRows,HatCompColIdx) ;
        Variables = Data(matchingRows, HatCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,8) ;
        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
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

    TickLabelsInit = CompDataTable{n,2} ;
    for n = 1:size(TickLabelsInit,1)
        TickLabels(n,1) = string(sprintf('S: %s, H: %s', TickLabelsInit(n,1), TickLabelsInit(n,2))) ;
    end
   
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

    path = "K:\Advancing TPP Paper - v2\Figure Folder\Figure 6 - Hatch Slice Comparison" ;
    PlotSize = [15, 5, 5.3*3, 4*3] ; 
    TitleFontSize = 18 ; 
    TextFontSize = 20 ; 

    % Create the plot
    fig1 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    %customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    customBoxPlot_withStats_v9(YSCell) ; 
    % ylim([10 45]) ;
    % yticks(linspace(10, 40, 4)) ;
    xticklabels(TickLabels);
    ylabel('Stress (MPa)', 'FontSize', 14);
    title('Yield Stress', 'FontSize', 14, 'FontWeight', 'bold');
    set(gca, 'FontSize', TextFontSize) ;
    title("Yield Stress, \sigma_y", 'FontSize',TitleFontSize)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName1 = 'Pow_YS_v1';
    filename1 = fullfile(path,fileName1);  % Set your desired file name
    print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig2 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    customBoxPlot_withStats_v9(Mods1Cell) ;
    % ylim([300 940]) ;
    % yticks(linspace(300,900,4)) ;
    xticklabels(TickLabels);
    ylabel('Moduli (MPa)', 'FontSize', 14);
    set(gca, 'FontSize', TextFontSize) ;
    title("Youngs Modulus, E_1", 'FontSize',TitleFontSize) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName2 = 'Pow_YM_v1';
    filename2 = fullfile(path,fileName2);  % Set your desired file name
    print(filename2, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig3 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    customBoxPlot_withStats_v9(Mods2Cell) ;
    % ylim([0.3 0.6]) ; 
    % yticks(linspace(0.3, 0.6, 4)) ;
    xticklabels(TickLabels);
    ylabel('Moduli Coef.', 'FontSize', 14);
    set(gca, 'FontSize', TextFontSize) ;
    title("2nd Modulus Coef. E_2/E_1", 'FontSize',TitleFontSize) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName3 = 'Pow_2M_v1';
    filename3 = fullfile(path,fileName3);  % Set your desired file name
    print(filename3, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig4 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    customBoxPlot_withStats_v9(Mods3Cell) ;
    % ylim([0.8 1.6]) ;
    % yticks(linspace(0.8,1.6,5)) ;
    xticklabels(TickLabels);
        ylabel('Moduli Coef.');
    set(gca, 'FontSize', TextFontSize) ;
    title("3rd Modulus Coef. E_3/E_1", 'FontSize',TitleFontSize) ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName4 = 'Pow_3M_v1';
    filename4 = fullfile(path,fileName4);  % Set your desired file name
    print(filename4, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig5 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    %subplot(1, 2, 1) ;
    customBoxPlot_withStats_v9(Lam1Cell) ;
    % ylim([0.15 0.3]) ;
    % yticks(linspace(0.15,0.3,4)) ;
    xticklabels(TickLabels);
    ylabel('Strain Coefficient', 'FontSize', 14);
    %title('Strain Coefficient');
    set(gca, 'FontSize', TextFontSize) ;
    title("Strain Coefficient 1, \lambda_1", 'FontSize',TitleFontSize)
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName5 = 'Pow_SC1_v1';
    filename5 = fullfile(path,fileName5);  % Set your desired file name
    print(filename5, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

    fig6 = figure('units', 'centimeters', 'position', PlotSize); hold on;
    customBoxPlot_withStats_v9(Lam2Cell) ;
    % ylim([0.8 1.2]) ;
    % yticks(linspace(0.8, 1.2, 5)) ;
    ylabel('Strain Coefficient', 'FontSize', 14);
    xticklabels(TickLabels);
    set(gca, 'FontSize', TextFontSize) ;
    title("Strain Coefficient 2, \lambda_2", 'FontSize',TitleFontSize);
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fileName6 = 'Pow_SC2_v1';
    filename6 = fullfile(path,fileName6);  % Set your desired file name
    print(filename6, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

end



