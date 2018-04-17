function[ wynik ] = Fala( Fi , alfa ,  indukcja  )
temporary = Fi ;
N = 201 ;
Bohr = 0.0529177249 ;
deltaX = 5./Bohr ;

mass = 0.067 ;

for i=2:(N-1) 
    temporary(i) = Fi(i) - alfa * ( -1./2./mass/deltaX/deltaX * ( Fi(i+1) -2.*Fi(i) + Fi(i-1) + indukcja(i) * Fi(i) ) ) ;
end

wynik = temporary ; 
