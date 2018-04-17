clc
clear
Bohr = 0.0529177249 ; % 1 bohr = tyle nm
Hartee = 27.2113845 ; % 1 hartee = tyle eV
Tau = 0.02418884326555 ; % 1 Tau = tyle femtosekund
N = 201 ;
L = 1000 ;  % nm wymiar pudla
deltaX = 5./Bohr ; % nm przeliczone na Bohry
deltaT = 1/Tau ; % fs przeliczone na Tau     0.1/Tau
Xo = 300 ; % nm
sigma = 50 ; % nm
k = -0.001 ;  % jednostki atomowe
mass = 0.067 ; % j. at.
odleglosc_d = 10./Bohr ; % nm przeskalowane na j.at.
epsilon = 13.5 ;
a = 1 ;
Energia1 = 5 ; 
Energia2 = 10 ; 
Fi = zeros(1,N) ; 
Secound = zeros(1,N) ; 
Indukcja = zeros(1,N) ; 

XXX = 0 ;
YYY = 0;
czas = 0;
Location = 0;
 Energia_zach = 0  ;
 Energia_niezach = 0;
for i=1:N
XXX(i) = (i-101.)/(N-1)*L ;
YYY(i) = Potential(i) ;
end

for i=2:(N-1)
    Fi(i) =  exp( -1*power( (i-101.)/(N-1.)*L-Xo , 2 )/power(sigma,2) ) +...
       1i* exp( -power( (i-101.)/(N-1.)*L-Xo , 2 )/power(sigma,2) )  ;
end

while  abs( Energia1-Energia2 ) > power( 10, - 6 )  
 Energia2 = Energia1 ;
 Fi = normalizacja(Fi) ;
        for i=1:N
        Indukcja(i) = Indukowany(Fi , i ) ;
        end
 Energia1 = Energy(Fi , Indukcja ) ;
 Fi = Fala(Fi, a , Indukcja ) ;
       
end
%%%%%%%%%%%%%%%%%% domnozony ped e(ikx) %%%%%%%%%%%
for i=2:(N-1)
    Fi(i) = Fi(i) * exp( 1i * k * (i-101.)/(N-1.)*L /Bohr  ) ;
end

%%%%%%%%%%%%%%%%%pierwszy krok obliczen czasowych %%%%%%%%%%%%
 Last = Fi ;
 for i=1:N
 Indukcja(i) = Indukowany(Fi , i ) ;
 end
 
 for i=2:(N-1)
 Fi(i) = Last(i) - 1i * deltaT * ( -1./2./mass/power(deltaX,2) *...
 ( Last(i+1) - 2.*Last(i) + Last(i-1) ) + ( Potential( i ) + Indukcja(i) ) * Last(i) ) ;
 
 end
 Fi = normalizacja(Fi ) ;


%%%%%%%%%%%%%%%%%  symulacja w czasie %%%%%%%%%%%%%%%%
t = 0 ;
while  t < 100000

    Second = Last ;
    Last = Fi ;
    %if mod(t, 10 )==0 
        for i=1:N
        Indukcja(i) = Indukowany(Fi , i ) ; 
        end
   % end
    for i = 2:(N-1)
        Fi(i) = Second(i) - 1i * 2. * deltaT * ( - 1./2./mass/power(deltaX,2) *...
        ( Last(i+1) -2.* Last(i) + Last(i-1) ) + ( Potential( i ) + Indukcja(i) ) * Last(i) ) ;
    end
    
    Fi = normalizacja(Fi ) ;
    
    t = t+1 ;
    
    
    if mod(t, 100 )==0 
   czas = [ czas t*deltaT ] ; 
   Location = [ Location Polozenie(Fi) ] ; 
   Energia_zach = [ Energia_zach Energia_zachowana(Fi, Indukcja ) ] ; 
   Energia_niezach = [ Energia_niezach Energia_niezachowana(Fi, Indukcja ) ];
    %clf
    %plot(XXX, abs(Fi).*abs(Fi) ,'.') ;
    %hold on ; 
    % plot(XXX,YYY) ; 
    %pause(0.0001) ;   
    end
    
end
Energia_niezach = Energia_niezach' ;
Energia_zach = Energia_zach' ; 
czas = czas' ;
Location = Location' ;




