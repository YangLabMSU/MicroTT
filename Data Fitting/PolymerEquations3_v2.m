function F = PolymerEquations3_v2(x, PV, Stress, Strain)

E1 = PV(1) ; 
ey = PV(2) ; 
sy = PV(3) ; 
eeq = PV(4) ;
seq = PV(5) ; 
ef = PV(6) ; 
sf = PV(7) ;

FirstIdx = find(Strain>=ey, 1, 'first') ; 
SecondIdx = find(Strain>=eeq, 1, 'first') ; 

e1 = 1:FirstIdx ;
e2 = FirstIdx:SecondIdx ; 
e3 = SecondIdx:length(Strain) ; 

e = [e1 e2 e3] ; 

F(1) = E1*ey^2 - x(1)*x(2)*exp(-(x(2)/ey)) - x(3)*x(4)*exp(-(x(4)/ey)) ; 
F(2) = E1*eeq^2 - x(1)*x(2)*exp(-(x(2)/eeq)) - x(3)*x(4)*exp(-(x(4)/eeq)) ;

i = 3 ; 
for n = e

    eval = Strain(n) ; 
    sval = Stress(n) ; 

    if eval > 0 
        F(i) = E1*eval - sval - x(1)*exp(-(x(2)/eval)) - x(3)*exp(-(x(4)/eval)) ;
        i = i + 1 ; 
    end

end


end