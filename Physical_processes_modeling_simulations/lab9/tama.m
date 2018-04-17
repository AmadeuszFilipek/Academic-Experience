clc
clear

L = 10 ; 
Width = 2 ; 
H_zero_przed = 4 ; 
H_zero_za = 3 ;  
x_t = 3 ;
f_dw = 80 ; % miedzy 10 a 100
g = 9.81 ; 
Tmax = 10000 ; % sekund
T_tics = 0 ; 
Time = 0 ;
dx = 0.1 ; % metra
x = 0:dx:10 ; % metry
N = length(x) ; 

S = -(0.1-0.6)/L ; % nachylenie koryta rzecznego
Q = zeros( 1 , N ) ; 
Q(1) = 1 ;
Q(N) = 0 ;
V = zeros( 1 , N ) ; 
h = zeros( 1 , N ) ; 
h(1: floor(x_t/dx) ) = H_zero_przed ; 
h(ceil(x_t/dx): N ) = H_zero_za ; 

A = h * Width ; 
R = A./ ( 2* h + Width ) ; 

%%%%%%%%%%%%% kryterium stabilnosci %%%%%%%%%
if abs( max(V)+sqrt( g*max( max(h) )) ) < abs( max(V)-sqrt( g*max( max(h) ) ) )
    dt = dx/100/abs( max(V)+sqrt( g*max( max(h) ) ) ) ; 
else
    dt = dx /100/abs( max(V)-sqrt( g*max( max(h) ) ) ) ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% obliczenia
for n=1:100000

%%%%%%%%%%%%% kryterium stabilnosci %%%%%%%%%
if abs( max(V)+sqrt( g*max( h ) ) ) < abs( max(V)-sqrt( g*max( h ) ) )
    dt = dx * 0.89/abs( max(V)+sqrt( g*max( h ) ) ) ; 
else
    dt = dx * 0.89 /abs( max(V)-sqrt( g*max( h ) ) ) ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


h_new =  zeros(1,N)  ; 
Q_new =  zeros(1,N)  ; 


for i=1:N-1
h_new( i ) = h(i) - dt/dx/Width * ( Q(i+1) - Q(i) ) ; 
end
h_new(N) =  H_zero_za ; 

A = h_new * Width ; 
V = Q./A ; 
%R = A./ ( 2* h_new + Width ) ; 



for i=2:N-1
Q_new(i) = -dt/2/dx*( Q(i+1)^2/A(i+1) - Q(i-1)^2/A(i-1) ) -dt*f_dw/8/R(i)*abs( V(i) )*Q(i) ...
   - dt*g*A(i) * ( h_new(i)/dx - h_new(i-1)/dx-S) + Q(i) ; 
end

 Q_new(1) = Q(1 ) ; 
Q_new(N) = Q_new(N-1) ;

Time = Time + dt ; 
T_tics = [ T_tics Time ] ; 

 plot( x , h_new ) 
pause( 0.001 ) 
if Time > 1.5
    
    plot( x , h_new )  % h_new
    title( [ 'Czas : ' num2str(Time) '[s]' ] ) ; 
    xlabel(' x [m]') ; 
    ylabel( ' h [m] ' ) ; 
    ylim( [3 4.1] ) ; 
    saveas( gcf , [num2str(Time) 'rozkladtst' '.jpg']  ) ;
    
    break 
  end


    if Time > Tmax 
    break 
    end
   
    h = h_new ;
    Q = Q_new ;
end
