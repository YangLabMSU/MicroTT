function [Parameters] = S0_Wonky_Parameter_Update(Parameters, ExpDets)

    % Organization Parameters
    Parameters.TestDate = ExpDets(1,1) ; 
    Parameters.Material = ExpDets(1,2) ; 
    Parameters.Condition = ExpDets(1,3) ; 
    Parameters.Substrate = ExpDets(1,4) ; 
    Parameters.ArrayPosition = ExpDets(1,5) ; 

    % Fabrication Parameters
    Parameters.WritingPower = ExpDets(1,7) ; 
    Parameters.WritingSpeed = ExpDets(1,8) ; 
    Parameters.BeamThickness = ExpDets(1,9) ; 
    Parameters.BeamHeight = ExpDets(1,10) ; 
    Parameters.FiberWidth = ExpDets(1,11) ; 
    Parameters.FiberHeight = ExpDets(1,12) ; 
    Parameters.FiberLength = 20 ; 
    Parameters.SliceDistance = ExpDets(1,13) ;
    Parameters.HatchDistance = ExpDets(1,14) ; 
    Parameters.HatchStyle = ExpDets(1,15) ; 

    % Experimental Parameters
    Parameters.DisplacementRate = ExpDets(1,16) ; 
    Parameters.DisplacementDistance = ExpDets(1,17) ; 
    Parameters.HoldDuration = ExpDets(1,18) ; 
    Parameters.Cycles = ExpDets(1,19) ; 
    Parameters.RecoveryDuration = ExpDets(1,20) ; 
    Parameters.Notes = ExpDets(1,22) ; 

    % Organization Parameters
    %Parameters.FolderName = ExpDets(1,21) ;
    %Parameters.VideoLoadPath = ExpDets(1,23) ;

end