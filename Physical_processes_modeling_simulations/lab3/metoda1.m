clc
clear
%% geometria 
Lenght = 100 ; % d³ugoœæ m
Width = 5  ;% szerokoœæ m
Height = 1 ;% g³êbokoœæ m
Avg_speed = 0.1 ; % œrednia prêdkoœæ przep³ywu 0.1m/s
Dyspersion = 0.01 ;%  wspó³czynnik dyspersji 0.01m2/s
Injection = 10 ;%  po³o¿enie punktu iniekcji 10m
Measurement = 90 ;% po³o¿enie punktu pomiarowego 90m
Marker_mass = 1 ;%  iloœæ wrzuconego znacznika 1kg


U_value = [] ;
Time = [] ; 
Detected = [] ; 
Mass = [] ;
for q = 0.1:0.01:1.5  %% petla do sprawdzenia stabilnosci numerycznej
    
Avg_speed = q ; % œrednia prêdkoœæ przep³ywu 0.1m/s
dx = 0.5 ; %- krok przestrzenny m 
dt = 1 ;%- krok czasowy s 
nt = 1000000 ;%  iloœæ kroków czasowych
nx  = Lenght/dx +1 ; %  iloœæ odcinków przestrzennych
Ca = Avg_speed * dt/dx ; % adwekcyjna liczba Couranta
Cd = Dyspersion * dt/dx/dx ; % dyfuzyjna liczba Couranta
x = 0:dx:Lenght ; 

Concentration = zeros( 1, nx ) ; 
% warunki poczatkowe ( 1 do wyboru , delta lub prostokat ) 
%Concentration( ceil( Injection/dx ) + 1 ) = Marker_mass / ( dx* Width * Height ) ; 
Concentration( ceil(5/dx): ceil(15/dx) ) = Marker_mass / ( dx * Width * Height * ( (15-5) /dx +1 ) ) ; 
%%%%%%%% przebieg obliczen %%%%%%%%%%%%%%%%%%%
C_next = Concentration ; 


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


 %Detected = [ Detected , Concentration( ceil(Measurement/dx) ) ] ; 
%Time = [ Time , i*dt ] ; 
 

 %if mass < Marker_mass*0.01 % warunek konca sym
 %    break 
% end
 
 if i*dt > 70/Avg_speed % warunek konca sym
     Mass = [ Mass mass ] ;
     U_value = [ U_value Avg_speed ]  ;
     break 
 end
 
end

end 

%plot( Time, Detected ) ;
%axis([0 1000 -0.001 0.02]) ;
%plot( x, Concentration ) ; 
%plot( Time, Mass ) ; 
plot( U_value, Mass ) ; 
axis([ 0.1 1.5 0 5 ] ) ;
xlabel(' U [m/s] ' ) ; 
ylabel(' M [kg] ' ) ;

%title( strcat('Metoda QUICKEST time = ', num2str(i*dt), ' [s] ' )  ) ; 
title( 'Metoda QUICKEST x = 70 [m]' ) ; 
saveas(gcf,'metoda1.jpg') ;

