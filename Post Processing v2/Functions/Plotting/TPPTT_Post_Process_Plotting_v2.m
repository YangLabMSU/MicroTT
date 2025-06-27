function TPPTT_Post_Process_Plotting_v2(ProcessedData)

    Time = ProcessedData.Time ; 
    TopDisplacement = ProcessedData.TopDisplacement ; 
    BottomDisplacement = ProcessedData.BottomDisplacement ; 
    ExpDist = ProcessedData.Parameters.DisplacementDistance ; 
    FiberStrain = ProcessedData.FiberStrain ; 
    PlateStrain = ProcessedData.PlateStrain ; 
    Force = ProcessedData.Force ;
    Stress = ProcessedData.Stress ; 

    % Plot Top Displacement to Check Displacement Analysis
    subplot(3,2,1);
    hold off ; 
    plot(Time, TopDisplacement, '-',  'color', '#800b30', 'linewidth', 3) ; hold on ; 
    yline(double(ExpDist), '--k', 'linewidth', 2) ; 
    yline(0, '--k', 'linewidth', 2) ; 
    title('Actuating Structure Displacement') ; 
    ylabel('Displacement (um)') ; 

    subplot(3,2,5) ;
    hold off ; 
    plot(Time, PlateStrain, '-', 'color', '#0d6994', 'linewidth', 4) ; hold on ; 
    plot(Time, FiberStrain, '-', 'color','#e8b91c', 'linewidth', 3) ;
    title('Fiber Strain') ; 
    ylabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain", 'location', 'south') ; 

    subplot(3,2,3) ; 
    hold off ; 
    yyaxis left; 
    plot(Time, Force, '-', 'color', '#0a8c2d', 'linewidth', 3) ; hold on ; 
    %plot(timeinterp, SmoothStress, '-', 'color', '#50c762', 'linewidth', 2) ;
    title('Force Calculated from Sensing Structure Displacement') ; 
    ylabel('Force (uN)') ; 
    xlabel('Time (s)') ;

    yyaxis right; 
    plot(Time, BottomDisplacement, '-', 'color', '#0a8c2d', 'linewidth', 3) ;  
    ylabel('Displacement (um)') ; 
    ylim('auto') ;

    yyaxis left;
    ylim([min((BottomDisplacement-0.1)*ProcessedData.Parameters.BeamStiffness) max((BottomDisplacement+0.5)*ProcessedData.Parameters.BeamStiffness)]);
    yyaxis right;
    ylim([min(BottomDisplacement-0.1) max(BottomDisplacement+0.5)]);

    ax = gca;
    ax.YAxis(2).Color = 'k';

    subplot(3,2,[2 4 6]) ; 
    hold off ; 
    plot(PlateStrain, Stress, '-', 'color', '#0d6994', 'linewidth', 4) ;  hold on ; 
    plot(FiberStrain, Stress, '-', 'color', '#e8b91c', 'linewidth', 3) ;
    xline(0,'--k') ; 
    yline(0,'--k') ; 
    title('Stress vs. Strain ')
    ylabel('Stress (uN / um^2)') ; 
    xlabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain", 'Location','northwest') ; 

end
