function StretchIdx = IdxSizeCheck(IdxSize, NumPts, StretchIdx)

if IdxSize > NumPts

    Diff = IdxSize - NumPts ;


    if Diff == 1

        StretchIdx(2) = StretchIdx(2) - 1 ;

    elseif Diff > 1

        isEven = mod(Diff, 2) == 0;

        if isEven

            Change = Diff / 2 ;
            StretchIdx(2) = StretchIdx(2) - Change ;
            StretchIdx(1) = StretchIdx(1) + Change ;

        else

            Change = (Diff-1) / 2 ;
            StretchIdx(2) = StretchIdx(2) - Change - 1 ;
            StretchIdx(1) = StretchIdx(1) + Change ;

        end


    end

elseif IdxSize < NumPts

    Diff = NumPts - IdxSize ;


    if Diff == 1

        StretchIdx(1) = StretchIdx(1) - 1 ;

    elseif Diff > 1

        isEven = mod(Diff, 2) == 0;

        if isEven

            Change = Diff / 2 ;
            StretchIdx(2) = StretchIdx(2) + Change ;
            StretchIdx(1) = StretchIdx(1) - Change ;

        else

            Change = (Diff-1) / 2 ;
            StretchIdx(2) = StretchIdx(2) + Change ;
            StretchIdx(1) = StretchIdx(1) - Change - 1 ;

        end


    end

end

if StretchIdx(1) < 1 

    ToOne = abs(StretchIdx(1)-1) ; 
    StretchIdx(1) = 1 ; 
    StretchIdx(2) = StretchIdx(2) + ToOne ; 

end

end
