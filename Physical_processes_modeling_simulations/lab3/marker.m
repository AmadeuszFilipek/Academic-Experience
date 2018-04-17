clc
clear
%% geometria 
Lenght = 100 ; % d�ugo�� m
Width = 5  ;% szeroko�� m
Height = 1 ;% g��boko�� m
Avg_speed = 0.1; % �rednia pr�dko�� przep�ywu 0.1m/s
Dyspersion = 0.01 ;%  wsp�czynnik dyspersji 0.01m2
Injection = 10 ;%  po�o�enie punktu iniekcji 10m
Measurement = 90 ;% po�o�enie punktu pomiarowego 90m
Marker_mass = 1 ;%  ilo�� wrzuconego znacznika 1kg

dx = 0.5 ; %- krok przestrzenny m 
dt = 1 ;%- krok czasowy s 
nt = 1000000 ;%  ilo�� krok�w czasowych
nx  = Lenght/dx +1 ; %  ilo�� odcink�w przestrzennych
Ca = Avg_speed * dt/dx ; % adwekcyjna liczba Couranta
Cd = Dyspersion * dt/dx/dx ; % dyfuzyjna liczba Couranta
x = 0:dx:Lenght ; 

Concentration = zeros( 1, nx ) ; 
% warunki poczatkowe 
Concentration( ceil( Injection/dx ) + 1 ) = Marker_mass / ( dx* Width * Height ) ; 
%%%%%%%% przebieg obliczen %%%%%%%%%%%%%%%%%%%
C_next = Concentration ; 
Time = [] ; 
Detected = [] ; 

for i=1:nt
    for j=3:nx-1
        
            C_next(j) = Concentration(j) + ( Cd*(1-Ca)-Ca/6*(Ca^2-3*Ca+2) )*Concentration(j+1) ...
                - ( Cd*(2-3*Ca)-Ca/2*(Ca^2-2*Ca-1) )*Concentration(j) ...
                + ( Cd*(1-3*Ca) -Ca/2*(Ca^2-Ca-2) )*Concentration(j-1) ...
                + (Cd*Ca + Ca/6*(Ca^2-1) )*Concentration(j-2) ; 

    end
 C_next(nx) = Concentration(nx-1) ;
 Concentration = C_next ;   
 
 mass = 0 ;
for k=1:nx
    mass = mass + Concentration(k) * ( dx* Width * Height ) ;
end

 mass 
 if mass < Marker_mass*0.05
     break 
 end
 
 Detected = [ Detected , Concentration( ceil(Measurement/dx) ) ] ; 
Time = [ Time , i*dt ] ; 
 %plot( x, Concentration ) ; 
 %pause(0.001); 
end

plot( Time, Detected ) ;
xlabel(' t [s] ' ) ; 
ylabel(' Concentration [kg/m3 ] ' ) ;


