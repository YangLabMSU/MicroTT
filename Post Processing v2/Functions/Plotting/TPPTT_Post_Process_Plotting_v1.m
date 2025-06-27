function TPPTT_Post_Process_Plotting_v1(Time, TopDisplacement, ExpDist, FiberStrain, PlateStrain, Force, Stress)

    % Plot Top Displacement to Check Displacement Analysis
    subplot(3,2,1);
    hold off ; 
    plot(Time, TopDisplacement, '-',  'color', '#116a85', 'linewidth', 3) ; hold on ; 
    yline(double(ExpDist), '--k', 'linewidth', 2) ; 
    yline(0, '--k', 'linewidth', 2) ; 
    title('Forcing Structure Displacement') ; 
    ylabel('Displacement (um)') ; 

    subplot(3,2,3) ;
    hold off ; 
    plot(Time, PlateStrain, '-', 'color', '#116a85', 'linewidth', 3) ; hold on ; 
    plot(Time, FiberStrain, '-', 'color','#4ecef5', 'linewidth', 2) ;
    title('Fiber Strain') ; 
    ylabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain") ; 

    subplot(3,2,5) ; 
    hold off ; 
    plot(Time, Force, '-', 'color', '#086316', 'linewidth', 3) ; hold on ; 
    %plot(timeinterp, SmoothStress, '-', 'color', '#50c762', 'linewidth', 2) ;
    title('Stress Calculated from Sensing Structure') ; 
    ylabel('Force (uN)') ; 
    xlabel('Time (s)') ;

    subplot(3,2,[2 4 6]) ; 
    hold off ; 
    plot(PlateStrain, Stress, '-', 'color', '#630a53', 'linewidth', 4) ;  hold on ; 
    plot(FiberStrain, Stress, '-', 'color', '#ff7086', 'linewidth', 4) ;
    xline(0,'--k') ; 
    yline(0,'--k') ; 
    title('Stress vs. Strain ')
    ylabel('Stress (uN / um^2)') ; 
    xlabel('Strain') ; 
    legend("Plate Strain", "Fiber Strain") ; 

end
