clear ; clc ; close ;

% Comparing Fitting Parameters of Similar Experiments
load('Average Ogden Experiments - v1.mat') ;
AveragedStretchExps = AveragedStretchExps(2:end,:) ;

load('Average Ogden Experiments - v1 - Table.mat') ;

% Generate the Figure for Plotting
PlotFig = figure('units', 'inches', 'Position', [10.8229,5.7604,5,4]); hold on;

% Set Colors for Plotting
n_colors = 4; % Number of colors you want to sample
parula_colors = parula(n_colors);

% Apply the new color order
set(gca, 'ColorOrder', parula_colors, 'NextPlot', 'replacechildren');
co = get(gca, 'ColorOrder');
n_colors = size(co, 1);

% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;

Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;
MatchTable = AverageTable(2:end,:) ;

% Look for Write Speed
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

        StressData = AveragedStretchExps(matchingRows,4) ;
        StrainData = AveragedStretchExps(matchingRows,5) ;

        Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
            ConstantParams(1,:)) ;

        for nn = 1:size(CompData,1)

            Stress = StressData{nn, 1}(:,1) ;
            StressStd = StressData{nn, 1}(:,2) ;
            Strain = StrainData{nn, 1}(:,1) ;

            XFill = [ Strain ; flip(Strain) ]  ;
            YFill = [ Stress-StressStd ; flip(Stress+StressStd)] ;
            fill( XFill, YFill, co(mod(nn-1, n_colors)+1, :), 'LineStyle', 'none', 'FaceAlpha', 0.3); hold on;
            plothandles(nn) = plot(Strain, Stress, 'color', co(mod(nn-1, n_colors)+1, :), 'linewidth', 4) ; hold on ;

            MaxStressVals(nn,1) = max(Stress) ;
            MaxStrainVals(nn,1) = max(Strain) ;

            SEMArea = SEMAreas{nn,1}(1,15) ; 

            LegendString(nn,1) = Variables(nn,1) + " x " + Variables(nn,2) ; % + ", Area: " + string(round(double(SEMArea),2)) + ' \mum^2' ;

        end

        leg = legend(plothandles, LegendString,...
            'Location', 'northwest', 'FontSize', 11, 'box', 'on', 'LineWidth', 4, 'edgecolor', 'none') ; , ...
            %'box', 'off') ;

        title(leg, 'Slice x Hatch (\mum)') ;

        ylim([0 90]) ;
        yticks(linspace(0,90,7)) ;

        xlim([-0.02 0.9]) ;
        xticks(round(linspace(0,0.9,7),2)) ;

        set(gca, 'FontSize', 18) ;
        xlabel('Strain') ;
        ylabel('Stress (MPa)') ;
        ax = gca;
        ax.Box = 'on';  % Turn on the box
        set(ax, 'BoxStyle', 'full');  % Ensure the box is drawn on all sides
        ax.LineWidth = 1.25 ; % Increase the axis line width
        ax.TickLength = [0.01 0.01]; % Increase the length of the tick marks
        grid on ;

        % Plot Save
        path = "K:\Yang Research\Two-Photon Polymerization\Analysis Code\DIC v12 - 4-26-24\Data Fitting\Ogden Fitting Plotting\Hatch Slice" ;
        fileName = n + "_SS-Plot";
        filename1 = fullfile(path,fileName);  % Set your desired file name
        print(filename1, '-djpeg', '-r300');  % Save as JPEG with 300 dpi resolution

        % Reset Figure and Values
        hold off ;
        clear MaxStressVals MaxStrainVals plothandles Stress StressStd Strain LegendString ;

    end
end