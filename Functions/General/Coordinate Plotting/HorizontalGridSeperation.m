function [Lines] = HorizontalGridSeperation(Grid)

[~, IA(1)] = ginput(1) ;             %Grid Initial (GI)
ML1 = [ Grid.XMin IA(1); Grid.XMax IA(1) ] ;
plot(ML1(:,1),ML1(:,2),'-b'); hold on     %Attaining and Plotting User Input
[~, IA(2)] = ginput(1) ;
ML2 = [ Grid.XMin IA(2); Grid.XMax IA(2) ] ;
plot(ML2(:,1),ML2(:,2),'-b'); hold on     %Attaining and Plotting User Input

if IA(1) < IA(2)

    Lines.TopLine = round(IA(1)) ;
    Lines.BottomLine = round(IA(2)) ;

else

    Lines.TopLine = round(IA(2)) ;
    Lines.BottomLine = round(IA(1)) ;

end

end