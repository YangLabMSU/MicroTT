clear ; clc ; close all ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Ogden Experiments - v1.mat') ;
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

load('Average Ogden Experiments - v1 - Table.mat') ;

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
MatchTable = AverageTable(2:end,:) ;

% Look for Hatch Slice Differences
HatCompColIdx = [1:5, 8 9] ;
HatCompCol = [ 6 7 ] ;
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');

i = 1 ;
for n = 1:size(HatComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (HatCidx == n) ;

    if sum(matchingRows) > 1

        disp([ sum(matchingRows) n ]) ;

        ConstantParams = Data(matchingRows,HatCompColIdx) ;
        Variables = Data(matchingRows, HatCompCol) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        CompData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,6) ;
        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            SEMArea = SEMAreas{nn,1}(:,15) ;
            FitParameters = CompData{nn,1} ;
            Yield = YieldData{nn,1} ;
            mu = FitParameters(:, [1 3]) ;
            alpha = FitParameters(:, [2 4]) ;
            Yields = Yield(:,[1 2]) ;
            % mu = FitParameters(2:end, [1 3]) ;
            % alpha = FitParameters(2:end, [2 4]) ;
            % Yields = Yield(2:end,[1 2]) ;

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



for n = 1:size(CompDataTable,1)

    mu = [] ;
    alpha = [] ;
    Yield = [] ;

    %[Variables, sort_index] = sort(Variables);
    %Sort = SortIdx{n,1} ;

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

    % Sort = [3 2 1] ; 
    % TickLabels = CompDataTable{n,2} ;
    % TickLabels = TickLabels(Sort) ;

    TickLabelsInit = CompDataTable{n,2} ;
    for nnnn = 1:size(TickLabelsInit,1)
        TickLabels(nnnn,1) = string(sprintf('%s x %s', TickLabelsInit(nnnn,1), TickLabelsInit(nnnn,2))) ;
    end

    for nn = 1:size(mu,2)

        if ~isempty(mu{1,nn})
            %nn = Sort(nn) ;

            mus = mu{1,nn} ;

            mu1 = mus(:,1) ;
            mu2 = mus(:,2) ;

            mu1Cell{1,nn} = mu1 ;
            mu2Cell{1,nn} = mu2 ;

            Alpha = alpha{1,nn} ;

            alpha1 = Alpha(:,1) ;
            alpha2 = Alpha(:,2) ;

            alpha1Cell{1,nn} = alpha1 ;
            alpha2Cell{1,nn} = alpha2 ;

            YieldStress = Yield{1,nn} ;

            YS = YieldStress(:,2) ;
            YStrain = YieldStress(:,1) ;
            YSCell{1,nn} = YS ;
            YStrainCell{1,nn} = YStrain ;

        end

    end

    PlotSavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Hatch Slice" ;

    FS = 18 ;

    % % Create the plot
    fig1 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;
    %customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    customBoxPlot_withStats_ForPaper_v8(YSCell) ;
    ylim([15 40]) ;
    yticks(linspace(15,40,6)) ;
    set(gca, 'FontSize', FS) ;
    ax = gca;
    ax.XAxis.FontSize = 11 ;  % Make x tick labels smaller
    xticklabels(TickLabels);
    ylabel('Stress (MPa)');
    xlabel('Slice x Hatch (\mum)', 'FontSize',14) ;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig2 = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;
    %customBoxPlot_noStats_ForPaper_v8(mu1Cell) ;
    customBoxPlot_withStats_ForPaper_v8(mu1Cell) ;
    ylim([350 750]) ;
    yticks(linspace(350,750,5)) ;
    set(gca, 'FontSize', FS) ;
    ax = gca;
    ax.XAxis.FontSize = 11 ;  % Make x tick labels smaller
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('Slice x Hatch (\mum)', 'FontSize',14) ;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig3 = figure('units', 'inches', 'Position', [ 21.10,5.78125,5,4 ]); hold on;
    %customBoxPlot_noStats_ForPaper_v8(mu2Cell) ;
    customBoxPlot_withStats_ForPaper_v8(mu2Cell) ;
    ylim([-350 -150]) ;
    yticks(linspace(-350,-150,5)) ;
    set(gca, 'FontSize', FS) ;
    ax = gca;
    ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('Slice x Hatch (\mum)', 'FontSize',14) ;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig4 = figure('units', 'inches', 'Position', [ 16,0.76,5,4 ]); hold on;
    %customBoxPlot_noStats_ForPaper_v8(alpha1Cell) ;
    customBoxPlot_withStats_ForPaper_v8(alpha1Cell) ;
    ylim([-25 -12.7]) ;
    yticks(linspace(-25, -13, 5)) ;
    set(gca, 'FontSize', FS) ;
    ax = gca;
    ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
    xticklabels(TickLabels);
    ylabel('Strain Exponent');
    xlabel('Slice x Hatch (\mum)', 'FontSize',14) ;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig5 = figure('units', 'inches', 'Position', [ 21.1,0.77,5,4 ]); hold on;
    %customBoxPlot_noStats_ForPaper_v8(alpha2Cell) ;
    customBoxPlot_withStats_ForPaper_v8(alpha2Cell) ;
    ylim([8 14.8]) ;
    yticks(linspace(8,14,4)) ;
    set(gca, 'FontSize', FS) ;
    ax = gca;
    ax.XAxis.FontSize = 12 ;  % Make x tick labels smaller
    xticklabels(TickLabels); 
    ylabel('Strain Exponent');
    xlabel('Slice x Hatch (\mum)', 'FontSize',14) ;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % Define the directory where the figure will be saved
    newFolder = 'Hatch Slice' ;

    % Check if the folder exists, if not, create it
    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end

    % Define the full path to save the JPEG file
    Details2 = sprintf("%s_Power-%s_Speed-%s_Wxh-%sx%s_Style-%s_SR-%s", ...
        ConstantParamsKeep(n,[1 2 3 4 5 6 7])) ;

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

    %close all ;
    clear YSCell YStrainCell alpha2Cell alpha1Cell mu2Cell mu1Cell ;

end
