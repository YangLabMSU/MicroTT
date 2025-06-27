function F = PolymerEquations_v2(x, PV, Stress, Strain)

E1 = PV(1) ; 
ey = PV(2) ; 
sy = PV(3) ; 
eeq = PV(4) ;
seq = PV(5) ; 
ef = PV(6) ; 
sf = PV(7) ;

FirstIdx = find(Strain>=ey, 1, 'first') ; 
SecondIdx = find(Strain>=eeq, 1, 'first') + 5 ; 

e1 = round(linspace(1, FirstIdx, 5)) ;
e2 = round(linspace(FirstIdx, SecondIdx, 20)) ; 
e3 = round(linspace(SecondIdx, length(Strain), 5)) ;

e = [e1 e2 e3] ; 

F(1) = x(1)*ey^2 - x(2)*x(3)*exp(-(x(3)/ey)) - x(4)*x(5)*exp(-(x(5)/ey)) ; 
F(2) = x(1)*eeq^2 - x(2)*x(3)*exp(-(x(3)/eeq)) - x(4)*x(5)*exp(-(x(5)/eeq)) ;

i = 3 ; 
for n = e

    eval = Strain(n) ; 
    sval = Stress(n) ; 

    if eval > 0 
        F(i) = x(1)*eval - sval - x(2)*exp(-(x(3)/eval)) - x(4)*exp(-(x(5)/eval)) ;
        i = i + 1 ; 
    end

end


end