clear ; clc ; close ; 

t = [ 10 15 20 ] ; 
k1 = [ 18.7 42.1 95.8 ] ; 
kfit = [ 12 40.5 96 ] ; 

n = (t.^3) ./ kfit ; 

k25 = 25^3 / mean(n) ; 