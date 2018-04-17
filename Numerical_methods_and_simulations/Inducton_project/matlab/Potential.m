function[wynik] = Potential( i )

 X_zero = 0 ; % nm
 a = 150 ; % nm
 V_zero = 0.00005 ; % j. at. 0.00005
 N = 201 ;
 L = 1000 ;  % nm wymiar pudla

   wynik = - 1. * V_zero * exp( -1. * power( ( (i-101.)/(N-1)*L - X_zero )/a ,2)  ) ;

