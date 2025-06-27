function SmoothFactor = AssignSmoothFactor(DisplacementRate)

    DisplacementRate = double(DisplacementRate) ; 
    
    % Set Smooth Factor Based on the Displacement Rates (um/s)
    if DisplacementRate == 1 || DisplacementRate == 2

        SmoothFactor = 15 ; 

    elseif DisplacementRate == 4

        SmoothFactor = 8 ; 

    elseif DisplacementRate < 1

        SmoothFactor = 20 ; 

    elseif DisplacementRate > 4

        SmoothFactor = 3 ; 

    end

end
