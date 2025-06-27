function F = PolymerEquations_2Term(x, PV, Stress, Strain)
 
ey = PV(2) ; 
eeq = PV(4) ;

FirstIdx = find(Strain>=ey, 1, 'first') ; 
SecondIdx = find(Strain>=eeq, 1, 'first') ; 

%e1 = round(linspace(1, FirstIdx, 5)) ;
e1 = 1:FirstIdx ;
%e2 = round(linspace(FirstIdx, SecondIdx, 20)) ; 
e2 = FirstIdx:SecondIdx ; 
e = [e1 e2] ; 

F(1) = x(1)*ey^2 - x(2)*x(3)*exp(-(x(3)/ey)) ; 
F(2) = x(1)*eeq^2 - x(2)*x(3)*exp(-(x(3)/eeq)) ;

i = 3 ; 
for n = e

    eval = Strain(n) ; 
    sval = Stress(n) ; 

    if eval > 0 
        F(i) = x(1)*eval - sval - x(2)*exp(-(x(3)/eval)) ;
        i = i + 1 ; 
    end

end


end