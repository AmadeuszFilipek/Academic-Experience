clc
clear

S_zero = 1366  ; %% W/m^2
c = 2.7 ; %% W/m^2/K
sigma = 5.67e-8 ; %% W/m^2/K^4  

Albedo = 0.3 ;

S  = 0.75 : 0.01 : 1.25 ; 
S = S * S_zero ;
Temp = power( S*(1-Albedo)/4/sigma , 1/4 )  ;

Temp = Temp - 273.15 ; 

plot( S , Temp )  ;
xlabel(' S [ W/m^2 ] ' ) ; 
ylabel(' T [C] ' ) ;
title( 'Bez atmosfery') ; 
saveas(gcf, 'bezatm.jpg' ) ; 

