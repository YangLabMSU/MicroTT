function TPPTT_Post_Process_Plotting_Cyclic_v1(ProcessedData, SmoothProcessedData)

    Time = ProcessedData.Time ; 
    TopDisplacement = ProcessedData.TopDisplacement ; 
    ExpDist = ProcessedData.Parameters.DisplacementDistance ; 
    FiberStrain = ProcessedData.FiberStrain ; 
    PlateStrain = ProcessedData.PlateStrain ; 
    Force = ProcessedData.Force ;
    Stress = ProcessedData.Stress ; 

    SmoothTime = SmoothProcessedData.Time ; 
    SmoothTopDisplacement = SmoothProcessedData.TopDisplacement ; 
    SmoothFiberStrain = SmoothProcessedData.FiberStrain ; 
    SmoothPlateStrain = SmoothProcessedData.PlateStrain ; 
    SmoothForce = SmoothProcessedData.Force ;
    SmoothStress = SmoothProcessedData.Stress ; 

    PlotFig = figure() ;
    PlotFig.Units = 'inches' ;
    PlotFig.Position = [16,1,6.5,8] ;

    % Plot Top Displacement to Check Displacement Analysis
    subplot(3,2,[1 2]);
    hold off ; 
    plot(Time, TopDisplacement, '-',  'color', '#116a85', 'linewidth', 4) ; hold on ; 
    plot(SmoothTime, SmoothTopDisplacement, '-',  'color', '#0fc7ff', 'linewidth', 3) ; hold on ;
    yline(double(ExpDist), '--k', 'linewidth', 2) ; 
    yline(0, '--k', 'linewidth', 2) ; 
    title('Forcing Structure Displacement') ; 
    ylabel('Displacement (um)') ; 
    legend("Raw", "Smoothed", 'location', 'southeast') ;

    subplot(3,2,[3 4]) ;
    hold off ; 
    plot(SmoothTime, SmoothPlateStrain, '-', 'color', '#0fc7ff', 'linewidth', 3) ; hold on ; 
    plot(SmoothTime, SmoothFiberStrain, '-', 'color','#045d78', 'linewidth', 3) ;
    % plot(Time, PlateStrain, '-', 'color', '#116a85', 'linewidth', 2) ; hold on ; 
    % plot(Time, FiberStrain, '-', 'color','#4ecef5', 'linewidth', 2) ;
    title('Fiber Strain') ; 
    ylabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain", 'location', 'southeast') ; 

    subplot(3,2,[5 6]) ; 
    plot(Time, Stress, '-', 'color', '#0fc7ff', 'linewidth', 4) ; hold on ;
    plot(SmoothTime, SmoothStress, '-', 'color', '#045d78', 'linewidth', 3) ; 
    title('Stress Calculated from Sensing Structure') ; 
    ylabel('Stress (MPa)') ; 
    xlabel('Time (s)') ;
    legend("Raw", "Smoothed", 'location', 'southeast') ;

    StressFig = figure('Units','inches','Position',[9,4,6.5,4]) ;  
    plot(SmoothPlateStrain, SmoothStress, '-', 'color', '#0fc7ff', 'linewidth', 4) ;  hold on ; 
    plot(SmoothFiberStrain, SmoothStress, '-', 'color', '#045d78', 'linewidth', 4) ;
    % plot(PlateStrain, Stress, '-', 'color', '#630a53', 'linewidth', 2) ;  hold on ; 
    % plot(FiberStrain, Stress, '-', 'color', '#ff7086', 'linewidth', 2) ;
    xline(0,'--k') ; 
    yline(0,'--k') ; 
    title('Stress vs. Strain ')
    ylabel('Stress (uN / um^2)') ; 
    xlabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain", 'location', 'northwest') ; 

end
