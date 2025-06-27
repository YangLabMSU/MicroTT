function [] = DrawRectangleGrid_v2(Coordinates, Color, Linewidth) 

GXMin = Coordinates(1,2) ; 
GYMin = Coordinates(1,1) ; 
GYMax = Coordinates(2,1) ; 
GXMax = Coordinates(2,2) ; 

% Creating the Rectangular Outline from the Grid Points
BL = [ GXMin GYMin ; GXMax GYMin ] ;        %Bottom Line (BL)
TL = [ GXMin GYMax ; GXMax GYMax ] ;        %Top Line (TL)
LL = [ GXMin GYMin ; GXMin GYMax ] ;        %Left Line (LL)
RL = [ GXMax GYMin ; GXMax GYMax ] ;        %Right Line (RL)

plot(BL(:,1),BL(:,2),'-','color', Color, 'linewidth', Linewidth) ; hold on ; %Plotting the Rectangle
plot(TL(:,1),TL(:,2),'-','color', Color, 'linewidth', Linewidth) ; 
plot(LL(:,1),LL(:,2),'-','color', Color, 'linewidth', Linewidth) ; 
plot(RL(:,1),RL(:,2),'-','color', Color, 'linewidth', Linewidth) ;

end
