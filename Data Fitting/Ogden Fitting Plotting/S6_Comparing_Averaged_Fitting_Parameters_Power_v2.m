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

% Look For Strain Rate
PowCompColIdx = [1:2, 4:size(Data,2)] ;
CompColumn = 3 ;
[PowerComps, ~, PCidx] = unique(Data(:,PowCompColIdx), 'rows');
i = 1 ;

for n = 4:size(PowerComps, 1)

    % Find the indices of rows matching the current parameter combination
    matchingRows = (PCidx == n) ;

    if sum(matchingRows) > 1

        disp([ sum(matchingRows) n ]) ;

        ConstantParams = Data(matchingRows,PowCompColIdx) ;
        Variables = Data(matchingRows, CompColumn) ;
        SEMAreas = AveragedStretchExps(matchingRows,1) ;
        FitData = AveragedStretchExps(matchingRows,7) ;
        YieldData = AveragedStretchExps(matchingRows,6) ;
        Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
            ConstantParams(1,[ 1 3:end-1])) ;

        for nn = 1:size(FitData,1)

            SEMArea = SEMAreas{nn,1}(:,15) ;
            FitParameters = FitData{nn,1} ;
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

        clear mu alpha Yields Yield FitParameters SEMArea FitData YieldData Details ConstantParams Variables ;

    end
end

for n = 1:size(muData,2)

    muDataNew{1,n} = [ muData{1,n} ; muData{2,n} ; muData{3,n} ] ;
    alphaDataNew{1,n} = [ alphaData{1,n} ; alphaData{2,n} ; alphaData{3,n} ] ;
    YSOutNew{1,n} = [ YSOut{1,n} ; YSOut{2,n} ; YSOut{3,n} ] ;

end

Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s", ...
    ConstantParamsKeep(1,[ 1 3:end-1])) ;

CompDataTableNew{1,1} = Details ;
CompDataTableNew{1,2} = CompDataTable{1,2} ;
[~, sort_index] = sort(double(CompDataTable{1,2}));
SortIdx{i,1} = sort_index ;

for n = 1:size(CompDataTableNew)

    mu = [] ;
    alpha = [] ;
    Yield = [] ;

    %[Variables, sort_index] = sort(Variables);
    Sort = SortIdx{n,1} ;

    mu = muDataNew(n,:) ;
    mu1 = [] ;
    mu2 = [] ;

    alpha = alphaDataNew(n,:) ;
    alpha1 = [] ;
    alpha2 = [] ;

    Yield = YSOutNew(n,:) ;
    YS = [] ;

    TickLabels = double(CompDataTableNew{n,2})*0.5 ;
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

    PlotSavePath = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Writing Power" ;
    FS = 18 ; 

    % % Create the plot
    fig1 = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;
    customBoxPlot_noStats_ForPaper_v8(YSCell) ;
    ylim([30 80]) ;
    yticks(linspace(30,80,6)) ;
    set(gca, 'FontSize', FS) ;
    xticklabels(TickLabels);
    ylabel('Stress (MPa)');
    xlabel('Writing Power (mW)') ;
    % title('Yield Stress, \sigma_y', 'FontWeight', 'bold')
    text(4, 75, 'Yield Stress, \sigma_y', 'FontSize', FS, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig2 = figure('units', 'inches', 'Position', [ 16.01,5.78125,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(mu1Cell) ;
    ylim([600 1800]) ;
    yticks(linspace(600,1800,6)) ;
    set(gca, 'FontSize', FS) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('mW') ;
    % title('\mu_1', 'FontWeight', 'bold')
    text(4.75, 1650, '\mu_1', 'FontSize', FS, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig3 = figure('units', 'inches', 'Position', [ 21.10,5.78125,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(mu2Cell) ;
    ylim([-900 -300]) ;
    yticks(linspace(-900,-300,6)) ;
    set(gca, 'FontSize', FS) ;
    xticklabels(TickLabels);
    ylabel('Modulus (MPa)');
    xlabel('mW') ;
    % title('\mu_2', 'FontWeight', 'bold')
    text(4.5, -370, '\mu_2', 'FontSize', FS, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig4 = figure('units', 'inches', 'Position', [ 16,0.76,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(alpha1Cell) ;
    ylim([-26 -14]) ;
    yticks(linspace(-26,-14,7)) ;
    set(gca, 'FontSize', FS) ;
    xticklabels(TickLabels);
    ylabel('Strain Exponent');
    xlabel('mW') ;
    % title('\alpha_1', 'FontWeight', 'bold')
    text(4.5, -15, '\alpha_1', 'FontSize', FS, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    fig5 = figure('units', 'inches', 'Position', [ 21.1,0.77,5,4 ]); hold on;
    customBoxPlot_noStats_ForPaper_v8(alpha2Cell) ;
    ylim([7 13]) ;
    yticks(linspace(7,13,7)) ;
    set(gca, 'FontSize', FS) ;
    xticklabels(TickLabels);
    ylabel('Strain Exponent');
    xlabel('mW') ;
    % title('\alpha_2', 'FontWeight', 'bold')
    text(4.5, 8.5, '\alpha_2', 'FontSize', FS, 'FontWeight', 'bold', 'HorizontalAlignment', 'center') ;
    ax = gca;
    ax.Box = 'on';  % Turn on the box
    set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
    ax.LineWidth = 1.25 ; % Increase the axis line width
    ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
    grid on ;

    % % Define the directory where the figure will be saved
    % newFolder = 'Speed and Power' ;
    % 
    % % Check if the folder exists, if not, create it
    % if ~exist(newFolder, 'dir')
    %     mkdir(newFolder);
    % end
    % 
    % % Define the full path to save the JPEG file
    % Details2 = sprintf("%s_Spd%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
    %     ConstantParamsKeep(n,:)) ;
    % 
    % disp(Details2);
    % 
    % fileName1 = "Pow_"+n+"_YS"+'_Fig1_v1'+'.tiff';
    % fileName2 = "Pow_"+n+"_mu1"+'_Fig2_v1'+'.tiff';
    % fileName3 = "Pow_"+n+"_mu2"+'_Fig3_v1'+'.tiff';
    % fileName4 = "Pow_"+n+"_alpha1"+'_Fig4_v1'+'.tiff';
    % fileName5 = "Pow_"+n+"_alpha2"+'_Fig5_v1'+'.tiff';
    % path = cd ;
    % fullFilePath1 = fullfile(path, newFolder, fileName1);
    % fullFilePath2 = fullfile(path, newFolder, fileName2);
    % fullFilePath3 = fullfile(path, newFolder, fileName3);
    % fullFilePath4 = fullfile(path, newFolder, fileName4);
    % fullFilePath5 = fullfile(path, newFolder, fileName5);
    % 
    % % Save the figure as a JPEG file
    % saveas(fig1, fullFilePath1, 'tiff');
    % saveas(fig2, fullFilePath2, 'tiff');
    % saveas(fig3, fullFilePath3, 'tiff');
    % saveas(fig4, fullFilePath4, 'tiff');
    % saveas(fig5, fullFilePath5, 'tiff');

    pause(1) ;
    hold off ;

    % close all ;
    clear YSCell YStrainCell alpha2Cell alpha1Cell mu2Cell mu1Cell ;

end
