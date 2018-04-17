function  [ wynik ] = Indukowany( Fi , a  )

suma = 0 ;
N = 201 ;
Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;
L = 1000 ;  % nm wymiar pudla
odleglosc_d = 10./Bohr ; 
epsilon = 13.5 ;

for i=1:(N-1)
    suma = suma + (  ( conj(Fi(i))*Fi(i) ) /...
                sqrt( power( (a-101.)/(N-1)*L/Bohr - (i-101.)/(N-1.)*L/Bohr , 2) + 4 * odleglosc_d*odleglosc_d) +...
                 ( conj(Fi(i+1))*Fi(i+1) ) /...
                sqrt( power( (a-101.)/(N-1)*L/Bohr - (i+1-101.)/(N-1)*L/Bohr , 2) + 4 * odleglosc_d*odleglosc_d) )...
                * deltaX/2 ;

end
wynik = -1./epsilon*suma  ;
