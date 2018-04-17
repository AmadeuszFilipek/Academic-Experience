function[ wynik ] = normalizacja( Fi )

Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;


suma = sum( conj(Fi).*Fi*deltaX ) ; 

wynik = Fi/sqrt(suma) ; 

