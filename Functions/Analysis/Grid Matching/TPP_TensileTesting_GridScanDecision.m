function [NPD,D] = TPP_TensileTesting_GridScanDecision(NPDI,NPDAP,NPDAN)
    
    [DAPMin,DAPMin_loc] = min(NPDAP) ;      %Find the minimum value of the positive displacements
    [DANMin,DANMin_loc] = min(NPDAN) ;      %Find the minimum value of the negative displacements
    Difcom = [ DAPMin DANMin NPDI ] ;      	%Difference Comparison (Difcom)
    [~,NPD_new_loc] = min(Difcom);          %Finding the Minimum Value to set the new pixel location

    if (NPD_new_loc == 1)

        NPD = DAPMin ; 
        D = DAPMin_loc ;
        
    elseif (NPD_new_loc == 2)

        NPD = DANMin ;  
        D = -DANMin_loc ;
        
    elseif (NPD_new_loc == 3)
        
        NPD = NPDI ;  
        D = 0 ;

    end
    
end