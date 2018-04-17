function[wynik]  = Energia_zachowana(  Fi,  ind ) 



Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;

suma = sum(conj(Fi).*Fi.* ind * deltaX ) ;

wynik = Energia_niezachowana(Fi , ind ) - 1./2.* suma ;
