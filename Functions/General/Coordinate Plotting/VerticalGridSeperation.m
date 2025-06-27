function [Lines] = VerticalGridSeperation(Grid)

[IA(1),~] = ginput(1) ;             %Grid Initial (GI)
ML1 = [ IA(1) Grid.YMin ; IA(1) Grid.YMax ] ;
plot(ML1(:,1),ML1(:,2),'-b'); hold on     %Attaining and Plotting User Input
[IA(2),~] = ginput(1) ;
ML2 = [ IA(2) Grid.YMin ; IA(2) Grid.YMax ] ;
plot(ML2(:,1),ML2(:,2),'-b'); hold on     %Attaining and Plotting User Input

if IA(1) < IA(2)

    Lines.LeftLine = round(IA(1)) ;
    Lines.RightLine = round(IA(2)) ;

else

    Lines.LeftLine = round(IA(2)) ;
    Lines.RightLine = round(IA(1)) ;

end

end