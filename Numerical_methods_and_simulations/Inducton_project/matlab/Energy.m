function [wynik] = Energy(Fi , indukcja ) 

suma = 0 ;
N = 201 ;
Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;
mass = 0.067 ; % j. at.

for i=2:(N-2) 

    suma = suma + ( conj( Fi(i) ) * ( -1./2./mass/deltaX/deltaX * ( Fi(i+1) -2.*Fi(i) + Fi(i-1) ) + indukcja(i) * Fi(i) ) +...
                conj( Fi(i+1) ) * ( -1./2./mass/deltaX/deltaX * ( Fi(i+2) -2.*Fi(i+1) + Fi(i) ) + indukcja(i+1) * Fi(i+1) ) )...
                * deltaX/2. ;
end
wynik = real(suma) ; % wynik w j. at.
