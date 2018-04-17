function [ wynik ] = Polozenie(  Fi )

suma = 0 ;
N = 201 ;
Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;
L = 1000 ;  % nm wymiar pudla

for i=1:N
suma = suma + ( real(Fi(i))*real(Fi(i))+imag(Fi(i))*imag(Fi(i)) ) * (i-101.)/(N-1)*L/Bohr * deltaX ; % L/bohr w jednostkach atomowych
end

wynik =  suma * Bohr ; % powrót z j. at.
