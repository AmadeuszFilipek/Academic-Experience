clc
clear
%% geometria 
Lenght = 100 ; % d�ugo�� m
Width = 5  ;% szeroko�� m
Height = 1 ;% g��boko�� m
Avg_speed = 0.1; % �rednia pr�dko�� przep�ywu 0.1m/s
Dyspersion = 0.01 ;%  wsp�czynnik dyspersji 0.01m2/s
Injection = 10 ;%  po�o�enie punktu iniekcji 10m
Measurement = 90 ;% po�o�enie punktu pomiarowego 90m
Marker_mass = 1 ;%  ilo�� wrzuconego znacznika 1kg

U_value = [] ;
Time = [] ; 
Detected = [] ; 
Mass = [] ;
for q = 0.1:0.01:1.5  %% petla do sprawdzenia stabilnosci numerycznej
    
    Avg_speed = q ; % �rednia pr�dko�� przep�ywu 0.1m/s
dx = 0.5 ; %- krok przestrzenny m 
dt = 1 ;%- krok czasowy s 
nt = 1000000 ;%  ilo�� krok�w czasowych
nx  = Lenght/dx +1 ; %  ilo�� odcink�w przestrzennych
Ca = Avg_speed * dt/dx ; % adwekcyjna liczba Couranta
Cd = Dyspersion * dt/dx/dx ; % dyfuzyjna liczba Couranta
x = 0:dx:Lenght ; 

Concentration = zeros( nx, 1) ; 
% warunki poczatkowe ( 1 do wyboru , delta lub prostokat ) 
%Concentration( ceil( Injection/dx ) + 1 ) = Marker_mass / ( dx* Width * Height ) ; 
Concentration( ceil(5/dx): ceil(15/dx) ) = Marker_mass / ( dx * Width * Height * ( (15-5) /dx +1 ) ) ; 
%%%%%%%% przebieg obliczen %%%%%%%%%%%%%%%%%%%
C_next = Concentration ; 

   AA = diag( ones(1,nx)*(1+Cd), 0 )...
            + diag( ones(1,nx-1)*(-Cd/2+Ca/4) , 1 )...
            + diag( ones(1,nx-1)*(-Cd/2-Ca/4) , -1 ) ; 
        
   BB = diag( ones(1,nx)*(1-Cd), 0 )...
            + diag( ones(1,nx-1)* (Cd/2-Ca/4) , 1 )...
            + diag( ones(1,nx-1)* (Cd/2+Ca/4) , -1 ) ;    
        
AB = AA^-1*BB ;
 AB(1,:) = 0 ; 
 AB( nx , :) = AB( nx-1 , : ) ;
 
for i=1:nt
    C_next = AB * Concentration ;    
 Concentration = C_next ;   
 
 mass = 0 ; 
for k=1:nx
    mass = mass + Concentration(k) * ( dx* Width * Height ) ;
end

%Mass = [ Mass, mass ] ; 
%Time = [ Time , i*dt ] ; 
%Detected = [ Detected , Concentration( ceil(Measurement/dx) ) ] ; 

% if mass < Marker_mass*0.90  % warunek konca sym
 %    break 
% end

if i*dt > 70/Avg_speed % warunek konca sym
      Mass = [ Mass mass ] ;
     U_value = [ U_value Avg_speed ]  ;
    break 
end
 
end

end

plot( U_value, Mass ) ; 
axis([ 0.1 1.5 0 5 ] ) ;
xlabel(' U [m/s] ' ) ; 
ylabel(' M [kg] ' ) ;

%title( strcat('Metoda Cranka-Nicolsona time = ', num2str(i*dt), ' [s] ' )  ) ; 
title( 'Metoda Cranka-Nicolsona x = 70 [m] ') ; 
 saveas(gcf,'metoda2.jpg') ; 
