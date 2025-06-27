clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Ogden Experiments - v1.mat') ;
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

load('Average Ogden Experiments - v1 - Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 2 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
MatchTable = AverageTable(2:end,:) ;

% Look for Write Speed
SpdCompColIdx = [1:3, 5:size(Data,2)] ;
SpdCompCol = 4 ;
[SpdComps, ~, SCidx] = unique(Data(:,SpdCompColIdx), 'rows');

i = 1 ;
for n = 1:size(SpdComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (SCidx == n) ;

    if sum(matchingRows) > 1

        disp([ sum(matchingRows) n ]) ;

        ConstantParams = Data(matchingRows,SpdCompColIdx) ;
        Variables = Data(matchingRows, SpdCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,6) ;
        Details = sprintf("%s, Power: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
            ConstantParams(1,[ 1 3:end])) ;

        for nn = 1:size(CompData,1)

            SEMArea = SEMAreas{nn,1}(:,15) ;
            FitParameters = CompData{nn,1} ;
            Yield = YieldData{nn,1} ;
            mu = FitParameters(:, [1 3]) ;
            alpha = FitParameters(:, [2 4]) ;
            Yields = Yield(:,[1 2]) ;

            muData{i,nn} = mu ;
            alphaData{i,nn} = alpha ;
            YSOut{i,nn} = Yields ;
            SEMOut{i,nn} = SEMArea ; 

        end

        [~, sort_index] = sort(double(Variables));
        SortIdx{i,1} = sort_index ;

        CompDataTable{i,1} = Details ;
        CompDataTable{i,2} = Variables ;
        CompDataTable{i,3} = SEMArea ;

        ConstantParamsKeep(i,:) = ConstantParams(1,:) ;

        i = i + 1 ;

        clear mu alpha Yields Yield FitParameters SEMArea CompData YieldData Details ConstantParams Variables ;

    end
end



for n = 1 %:size(CompDataTable)

    mu = [] ;
    alpha = [] ;
    Yield = [] ;

    %[Variables, sort_index] = sort(Variables);
    Sort = SortIdx{n,1} ;

    mu = muData(n,:) ;
    mu1 = [] ;
    mu2 = [] ;

    alpha = alphaData(n,:) ;
    alpha1 = [] ;
    alpha2 = [] ;

    Yield = YSOut(n,:) ;
    YS = [] ;

    SEM = SEMOut(n,:) ; 
    SEMA2 = [] ; 

    TickLabels = CompDataTable{n,2} ;
    TickLabels = TickLabels(Sort) ;

    for nn = 1:size(mu,2)

        if ~isempty(mu{1,nn})
            nnn = Sort(nn) ;

            mus = mu{1,nnn} ;

            mu1 = mus(:,1) ;
            mu2 = mus(:,2) ;

            mu1Cell{1,nn} = mu1 ;
            mu2Cell{1,nn} = mu2 ;

            Alpha = alpha{1,nnn} ;

            alpha1 = Alpha(:,1) ;
            alpha2 = Alpha(:,2) ;

            alpha1Cell{1,nn} = alpha1 ;
            alpha2Cell{1,nn} = alpha2 ;

            YieldStress = Yield{1,nnn} ;

            YS = YieldStress(:,2) ;
            YStrain = YieldStress(:,1) ;
            YSCell{1,nn} = YS ;
            YStrainCell{1,nn} = YStrain ;

        end

    end

    PlotSavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Writing Speed" ;

    % % Create the plot
    fig1 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;
    customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    yLimits = ylim ;
    ylim([10 60]) ; 
    yticks(linspace(10,60,6)) ; 
    set(gca, 'FontSize', 14) ;
    xticklabels(TickLabels);
    ylabel('Stress (MPa)');
    xlabel('Write Speed (mm/s)') ; 
    % title('Yield Stress, \sigma_y', 'FontWeight', 'bold')
    text(8, 55, 'Yield Stress, \sigma_y', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig2 = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(mu1Cell) ;
    ylim([200 1400]) ; 
    yticks(linspace(200,1400,6)) ; 
    set(gca, 'FontSize', 14) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('mm/s') ; 
    %title('\mu_1', 'FontWeight', 'bold')
    text(9, 1300, '\mu_1', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig3 = figure('units', 'inches', 'Position', [ 21.10,5.78125,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(mu2Cell) ;
    ylim([-700 -100]) ; 
    yticks(linspace(-700,-100,6)) ; 
    set(gca, 'FontSize', 14) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('mm/s') ; 
    % title('\mu_2', 'FontWeight', 'bold')
    text(2, -150, '\mu_2', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig4 = figure('units', 'inches', 'Position', [ 16,0.76,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(alpha1Cell) ;
    ylim([-26 -16]) ; 
    yticks(linspace(-26,-16,6)) ; 
    set(gca, 'FontSize', 14) ;
    xticklabels(TickLabels);
    ylabel('Strain Exponent');
    xlabel('mm/s') ; 
    %title('\alpha_1', 'FontWeight', 'bold')
    text(2, -17, '\alpha_1', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig5 = figure('units', 'inches', 'Position', [ 21.1,0.77,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(alpha2Cell) ;
    ylim([8 13]) ; 
    yticks(linspace(8,13,6)) ; 
    set(gca, 'FontSize', 14) ;
    xticklabels(TickLabels);
    ylabel('Strain Exponent');
    xlabel('mm/s') ; 
    % title('\alpha_2', 'FontWeight', 'bold')
    text(9, 12.5, '\alpha_2', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % Define the directory where the figure will be saved
    newFolder = 'Writing Speed' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    Details2 = sprintf("%s_Spd%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
        ConstantParamsKeep(n,:)) ;

    disp(Details2);

    fileName1 = n+"_YS"+'_Fig1_v1'+'.tiff';
    fileName2 = n+"_mu1"+'_Fig2_v1'+'.tiff';
    fileName3 = n+"_mu2"+'_Fig3_v1'+'.tiff';
    fileName4 = n+"_alpha1"+'_Fig4_v1'+'.tiff';
    fileName5 = n+"_alpha2"+'_Fig5_v1'+'.tiff';
    path = cd ;
    fullFilePath1 = fullfile(path, newFolder, fileName1);
    fullFilePath2 = fullfile(path, newFolder, fileName2);
    fullFilePath3 = fullfile(path, newFolder, fileName3);
    fullFilePath4 = fullfile(path, newFolder, fileName4);
    fullFilePath5 = fullfile(path, newFolder, fileName5);

    % Save the figure as a JPEG file
    saveas(fig1, fullFilePath1, 'tiff');
    saveas(fig2, fullFilePath2, 'tiff');
    saveas(fig3, fullFilePath3, 'tiff');
    saveas(fig4, fullFilePath4, 'tiff');
    saveas(fig5, fullFilePath5, 'tiff');

    pause(1) ;
    hold off ;

    % close all ; 
    clear YSCell YStrainCell alpha2Cell alpha1Cell mu2Cell mu1Cell ;

end
