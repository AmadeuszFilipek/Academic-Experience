clc
clear

dx = 0.01 ; 
dy = 0.01 ;
dt = 0.1 ;
A = 0.4 ;
B = 0.3 ;
C = 0.05 ; 
D = 0.1 ; 
h = 0.001 ; 
ro = 8920 ; % miedz
cw = 380 ;
K = 401 ;
Nt = 100000 ;
Nx = 41 ; 
Ny = 41 ; 

x = 0:dx:0.4 ;
y = 0:dy:0.4 ;
T = zeros( Ny, Nx ) ;
flag = T ; 
% warunki brzegowe 
T( : , ceil( C /dx ) : ceil( (A-C)/dy) ) = 20 ;
T( ceil( (A - D)/dy ):Ny, : ) = 20 ; 
T( 1, ceil( C /dx ) : ceil( (A-C)/dy) ) = 10 ;
T(Ny,: ) = 10 ; 
T( ceil( (A - D)/dy ), 1:ceil(C/dx) ) = 10 ; 
T(ceil( (A - D)/dy ) , ceil( (A-C)/dx):Nx ) = 10 ; 
T(ceil( (A - D)/dy):Ny, 1  ) = 10 ; 
T( ceil( (A - D)/dy):Ny, Nx ) = 10 ;
T(  1:ceil( (A-D)/dy)  , ceil(C/dx ) ) = 10 ; 
T(  1:ceil( (A-D)/dy)  , ceil((B+C)/dx ) ) = 10 ; 
T( ceil( (A/2-D/2)/dy)-1: ceil( (A/2+D/2)/dy ) , ceil ( (A/2-D/2)/dx)-1 : ceil( (A/2+D/2)/dx) )= 80 ;
% tablica flag obliczeñ 
% 0 - brak obliczen , 1 - normalne obliczenia
flag( : , ceil( C /dx ) : ceil( (A-C)/dx) ) = 1 ;
flag( ceil( (A - D)/dy ):41, : ) = 1 ; 
flag( 1, ceil( C /dx ) : ceil( (A-C)/dx) ) = 0 ;
flag(41,: ) = 0 ; 
flag( ceil( (A - D)/dy ), 1:ceil(C/dx) ) = 0 ; 
flag(ceil( (A - D)/dy ) , ceil( (A-C)/dx):41 ) = 0 ; 
flag(ceil( (A - D)/dy):41, 1  ) = 0 ; 
flag( ceil( (A - D)/dy):41, 41 ) = 0 ;
flag(  1:ceil( (A-D)/dy)  , ceil(C/dx ) ) = 0 ; 
flag(  1:ceil( (A-D)/dy)  , ceil((B+C)/dx ) ) = 0 ; 

flag( ceil( (A/2-D/2)/dy)-1: ceil( (A/2+D/2)/dy ) , ceil ( (A/2-D/2)/dx)-1 : ceil( (A/2+D/2)/dx) ) = 0 ;
%%%%%%%%%%%%%%
%%% przebieg symulacji 
T_next = T ; 

for t=1:Nt
    for i=1:Nx
        for j=1:Ny
            if flag(i,j) == 1
                T_next(i,j) = T(i,j) + K*dt / cw / ro / dx^2 * ( T( i+1,j ) - 2*T( i,j ) + T( i-1,j ) ) + ...
                    K*dt / cw / ro / dy^2 * ( T( i, j+1 ) - 2*T( i,j ) + T(i, j-1 ) ) ; 
            end
        end

    end
    


  if sum( sum( (T_next - T).^2 )) < 0.0001
     break 
  end 
  if t*dt == 5
     break 
  end 
 T = T_next ; 
end
 
[A , B ] = contourf(x ,y , T_next , 100 ) ; 
set(B,'LineColor','none') ;  
colormap( 'hot' ) ; 
colorbar ; 
xlabel(' x [cm] ' ) ; 
ylabel(' y [cm] ' ) ;
title( strcat('time = ', num2str(t*dt), ' [s] ' )  ) ; 
%pause(0.0001) ; 
saveas(gcf,'wykres.jpg')