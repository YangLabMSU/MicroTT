function BeamStiffness = BeamStiffnessAssign(BeamThickness)

    BeamThickness = double(BeamThickness) ; 
    
    if BeamThickness == 10 

        BeamStiffness = 18.7 ; 
        disp(BeamStiffness) ;
        
    elseif BeamThickness == 15

        BeamStiffness = 42.1 ; % uN / um
        disp(BeamStiffness) ;

    elseif BeamThickness == 20

        BeamStiffness = 95.8 ; % uN / um
        disp(BeamStiffness) ;

    elseif BeamThickness == 25

        BeamStiffness = 187.5 ; 
        disp(BeamStiffness) ;

    end

end
