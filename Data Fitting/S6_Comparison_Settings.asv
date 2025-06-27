clear ; clc ; close ;

% Organization Sheet For Comparisons

% Comparing Fitting Parameters of Similar Experiments
load('Average Stretch Experiments Fits.mat') ;
load('Average Stretch Table.mat') ;
% Generate Comparisons of Averages
ComparisonColumns = [ 1 6:12 16 ] ;
Headers = AverageTable(1, ComparisonColumns) ;
Data = AverageTable(2:end,ComparisonColumns) ;

% Power
PowCompColIdx = [1, 3:size(Data,2)] ;
PowCompColumn = 2 ;
[PowerComps, ~, PCidx] = unique(Data(:,PowCompColIdx), 'rows');

Variables = (double(Data(matchingRows, CompColumn)).*50)/100 ;
Details = sprintf("%s, Speed: %s mm/s, w x h: %s x %s um, S x H: %s x %s um, Style: %s, Strain Rate: %s um/s", ...
    ConstantParams(1,:)) ;
% Define the full path to save the JPEG file
Details2 = sprintf("%s_Spd%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
    ConstantParamsKeep(n,:)) ;

% Speed
SpdCompColIdx = [1:2, 4:size(Data,2)] ;
SpdCompCol = 3 ;
[SpdComps, ~, SCidx] = unique(Data(:,SpdCompColIdx), 'rows');
Details = sprintf("%s, Power: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
    ConstantParams(1,:)) ;
Details2 = sprintf("%s_Pow%s_WxH%sx%s_SxH%sx%s_%s_StrainRate%s", ...
    ConstantParams(1,:)) ;

% Strain Rate
SRCompColIdx = 1:size(Data,2)-1 ;
[StrainRateComps, ~, SRCidx] = unique(Data(:,SRCompColIdx), 'rows');
SRCompCol = size(Data,2) ;
Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s, SxH: %s x %s, Style: %s", ...
    ConstantParams(1,:)) ;
Details2 = sprintf("%s_Pow%s_Spd%s_WxH%sx%s_SxH%sx%s_%s", ...
    ConstantParams(1,:)) ;

% Hatch x Slice
HSCompColIdx = [1:5, 8:size(Data,2)] ;
HSCompCol = [ 6 7 ] ;
[HSComps, ~, HSCidx] = unique(Data(:,HSCompColIdx), 'rows');
Vary(nn) = Variables(nn,1) + 'x' + Variables(nn,2) ;
Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s, Style: %s, Strain Rate: %s", ...
    ConstantParams(1,:)) ;
Details2 = sprintf("%s_Power%s_Spd%s_WxH%sx%s_SxH%sx%s_StrainRate%s", ...
    ConstantParams(1,:)) ;


% Height x Width
WHCompColIdx = [1:3, 6:size(Data,2)] ;
WHCompCol = [ 4 5 ] ;
[WHComps, ~, WHCidx] = unique(Data(:,WHCompColIdx), 'rows');
Vary(nn) = Variables(nn,1) + 'x' + Variables(nn,2) ;
Details = sprintf("%s, Power: %s, Speed: %s, SxH: %s x %s, Style: %s, Strain Rate: %s", ...
    ConstantParams(1,:)) ;
Details2 = sprintf("%s_Pow%s_Spd%s_SxH%sx%s_%s_StrainRate%s", ...
    ConstantParams(1,:)) ;



% Hatch Style
HatCompColIdx = [1:7, size(Data,2)] ;
HatCompCol = 8 ;
[HatComps, ~, HatCidx] = unique(Data(:,HatCompColIdx), 'rows');
Details = sprintf("%s, Power: %s, Speed: %s, Wxh: %s x %s,  SxH: %s x %s, Strain Rate: %s", ...
    ConstantParams(1,:)) ;
Details2 = sprintf("%s_Power%s_Spd%s_WxH%sx%s_SxH%sx%s_StrainRate%s", ...
    ConstantParams(1,:)) ;

% SEM Comparison
SEMConditions = [ 1 ; 2 ; 3 ] ;
ComparisonColumns = [ 1 13 16 6:12 ] ;
SEMCompColIdx = [1, 3] ;
[SEMComps, ~, SEMCidx] = unique(Data(:,SEMCompColIdx), 'rows');

if nnn == 1
    SEMRows = (double(Data(:, 2)) < 5) ;
elseif nnn == 2
    SEMRows = (double(Data(:, 2)) < 8 & double(Data(:,2)) > 4) ;
elseif nnn == 3
    SEMRows = (double(Data(:,2)) > 8 ) ;
end

if nnn == 1
    Details = sprintf("%s, Strain Rate: %s, Less than 5 um^2 Area", ...
        ConstantParams(1,:)) ;
elseif nnn == 2
    Details = sprintf("%s, Strain Rate: %s, Between 4 to 8 um^2 Area", ...
        ConstantParams(1,:)) ;
elseif nnn == 3
    Details = sprintf("%s, Strain Rate: %s, Greater than 8 um^2 Area", ...
        ConstantParams(1,:)) ;
end


