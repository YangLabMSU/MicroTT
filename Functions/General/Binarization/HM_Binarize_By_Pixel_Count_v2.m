function [BWGrid, nset] = HM_Binarize_By_Pixel_Count_v2(Grid, Thresh, valset, Pixels)
% Begin Function
NPG = numel(Grid);

%Set Limits
ThreshHigh = Thresh + 0.001 ;
ThreshLow = Thresh - 0.001 ;

val = valset ;
idx = size(find(Grid<val));
BWR = idx(1)/Pixels;

count = 1 ;
zl = 0 ;
zll = 0 ;
while BWR < ThreshLow || BWR > ThreshHigh

    if BWR > ThreshLow
        val = val - 1 ;
        z = 1 ;
    elseif BWR < ThreshHigh
        val = val + 1 ;
        z = 2 ;
    end

    idx = size(find(Grid<val));
    BWR = idx(1)/Pixels ; 

    if count > 255
        disp('Shit');
        % BWR = min(BWRVal) ; 
        break
    elseif ( z == 1 && zl == 2)
        if zll == 1
            %             disp('dip out');
            break
        end
    elseif ( z == 2 && zl == 1 )
        if zll == 2
            %             disp('dip out');
            break
        end
    end

    zll = zl ;
    zl = z ; 

    count = count + 1 ;
    
end

for nn = 1:1:NPG
    if Grid(nn) < val
        Grid(nn) = 0 ;
    else
        Grid(nn) = 1 ;
    end
end

BWGrid = double(Grid);
nset = val ; 

end