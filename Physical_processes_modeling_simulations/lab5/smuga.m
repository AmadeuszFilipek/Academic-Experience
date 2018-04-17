clc
clear

atm = 'silnie chwiejna' ;
u_a = 3 ; % predkosc wiatru na wysokosci 14 m ze skokiem co 1 m/s (tabela 2. )
m = 0.08 ; % stala zalezna od stanu rownowagi atm ( na podstawie tabeli 3. )
a = 0.888 ; % stala zalezna od row atm. ( tab 3 ) 
b = 1.284 ;  % stala zal. od row atm. ( tab 3 ) 
nazwa = strcat( atm , '_', num2str(u_a) , '.jpg')  ;  

h= 120 ; % wysokosc geometryczna komina
dh = 0.15 * h ; % wysokosc wylotu gazow
H = h + dh ;  % wysokosc efektywna komina
Eg = 5760/365/24/60/60*1e9 ;  % emisja substancji gazowej ( usredniona po godzinie ) mg/s

z_0 = 1.5 ; % szorstkosc terenu strefa zabudowana srednia

u_h = u_a * power(h/14, m ) ; 
u_s = u_a /(1+m) * power( H/14 , m ) ;
u_av = u_a / ( H - h ) / (1+m)/14^m * ( H^(1+m) - h^(1+m) ) ; 

A = 0.088 * ( 6*m^(-0.3) + 1 - log( H / z_0 ) ) ; % stale przed sigmami
B = 0.38 * m^(1.3)*( 8.7 - log(H/z_0 ) ) ; 

if u_h < 0.5 
    string 'wyjatek u_h'
end
if u_s < 0.5
    string 'wyjatek u_as'
    end
if u_av < 0.5
    string 'wyjatek u_av'
    end
if H/z_0 < 10 
    string 'wyjatek H/z_0'
    end
if H/z_0 > 1500 
    string 'wyjatek H/z_0'
    end
   
  % sig_y = (A * x^a) ; 
 %  sig_z = ( B *x^b ) ; 
   syms x y z ; 
    
Sxyz = symfun( Eg/2/pi/u_av/(A * x^a)/( B *x^b ) * exp(-y^2/2/(A * x^a)^2) ...
    *( exp( - (z-H)^2/2/( B *x^b )^2) + exp( - (z+H)^2/2/( B *x^b )^2) ) * 1000 , [x y z ] ) ; 

Sxy = symfun( Eg/pi/u_av/(A * x^a)/( B *x^b ) * exp(-y^2/2/(A * x^a)^2) ...
    *exp( - (H)^2/2/( B *x^b )^2)  * 1000 ,[ x y ] ) ; 

Sxz = symfun( Eg/2/pi/u_av/(A * x^a)/( B *x^b ) ...
    *( exp( - (z-H)^2/2/( B *x^b )^2) + exp( - (z+H)^2/2/( B *x^b )^2) ) * 1000 ,[x z ] ) ; 

Sx = symfun( Eg/pi/u_av/(A * x^a)/( B *x^b ) * exp( - (H)^2/2/( B *x^b )^2)  * 1000 , [ x ] ) ; 

ezplot( Sx , [1:1000] )  ;
title( strcat('atmosfera - ' , atm )  ) ; 
xlabel(' x [ m ] ') ; 
ylabel( ' C [ ug/m3 ] ' ) ; 

saveas(gcf , nazwa )  ;
double( Sx(7200) ) 
