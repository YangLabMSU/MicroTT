function [GridDetails] = RectangularGridSelection() 

%User Input to Select Grid
[GI(1,1),GI(1,2)] = ginput(1) ;             %Grid Initial (GI)       
    plot(GI(1,1),GI(1,2),'+b'); hold on     %Attaining and Plotting User Input 
[GI(2,1),GI(2,2)] = ginput(1) ;             
    plot(GI(2,1),GI(2,2),'+b'); hold on
        
%Plotting Grid Selection
%First to find and associate each corner with a min and max
GXMin = round(min(GI(:,1)));    %Grid_X-axis_Minimum
GXMax = round(max(GI(:,1)));    %Grid_X-axis_Maximum
GYMin = round(min(GI(:,2)));    %Grid_Y-axis_Minimum
GYMax = round(max(GI(:,2)));    %Grid_Y-axis_Maximum

%Creating the Rectangular Outline from the Grid Points
BL = [ GXMin GYMin ; GXMax GYMin ] ;        %Bottom Line (BL)
TL = [ GXMin GYMax ; GXMax GYMax ] ;        %Top Line (TL)
LL = [ GXMin GYMin ; GXMin GYMax ] ;        %Left Line (LL)
RL = [ GXMax GYMin ; GXMax GYMax ] ;        %Right Line (RL)
plot(BL(:,1),BL(:,2),'-b',TL(:,1),...
    TL(:,2),'-b',LL(:,1),LL(:,2),...
    '-b',RL(:,1),RL(:,2),'-b'); hold on     %Plotting the Rectangle

GridDetails.XMin = GXMin ; 
GridDetails.XMax = GXMax ; 
GridDetails.YMin = GYMin ; 
GridDetails.YMax = GYMax ; 

end