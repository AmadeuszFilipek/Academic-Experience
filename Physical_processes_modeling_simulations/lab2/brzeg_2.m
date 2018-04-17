clc
clear

dx = 0.01 ; 
dy = 0.01 ;
dt = 0.21 ;
A = 0.4 ;
B = 0.3 ;
C = 0.05 ; 
D = 0.1 ; 
h = 0.001 ; 
ro = 8920 ; % miedz
cw = 380 ;
K = 401 ;
P = 100 ; %% moc grzalki [ Wat ]
dT = P * dt / cw / D^2 / h / ro ; % przyrost temp. w 1 kroku dla elementów styczych z grza³k¹
Nt = 100000 ;
Nx = A/dx+1 ; 
Ny = A/dy+1 ; 

x = 0:dx:0.4 ;
y = 0:dy:0.4 ;
T = zeros( Ny, Nx ) ;
flag = T ;  
%% warunki brzegowe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T( : , ceil( C /dx ) : ceil( (A-C)/dy) ) = 20 ;
T( ceil( (A - D)/dy ):Ny, : ) = 20 ; 
%% tablica flag obliczeñ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0 - brak obliczen , 10 - normalne obliczenia , 20 - obliczenia dla grzalki
% 1 - brzeg gorny, 2 - brzeg lewy(pionowy), 3 - brzeg dolny(poziomy),
% 4 - brzeg prawy(pionowy), 12 - naro¿e lewe górne, 23 naro¿e lewe dolne, 34 naro¿e prawe dolne, 
% 32 - naro¿e lewe specjalne, 43 - naro¿e prawe specjalne,
%41 - naro¿e prawe górne
flag( : , ceil( C /dx ) : ceil( (A-C)/dx) ) = 10 ;
flag( ceil( (A - D)/dy ):Ny, : ) = 10 ; 
%% dla linii brzegowych %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag(Ny,: ) = 1 ;
flag( 1, ceil( C /dx ) : ceil( (A-C)/dx) ) = 3 ;
flag( ceil( (A - D)/dy ), 1:ceil(C/dx) ) = 3 ; 
flag(ceil( (A - D)/dy ) , ceil( (A-C)/dx):Nx ) = 3 ; 
flag(ceil( (A - D)/dy):Ny, 1  ) = 2 ; 
flag( ceil( (A - D)/dy):Ny, Nx ) = 4 ;
flag(  1:ceil( (A-D)/dy)  , ceil(C/dx ) ) = 2 ; 
flag(  1:ceil( (A-D)/dy)  , ceil((B+C)/dx ) ) = 4 ; 
%% dla punktow brzegowych %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag(Ny,1) = 12 ; 
flag( ceil( (A - D)/dy ) , 1 ) = 23 ; 
flag( ceil( (A - D)/dy ), ceil(C/dx ) ) = 32 ; 
flag( 1, ceil(C/dx ) ) = 23 ; 
flag( 1, ceil((B+C)/dx ) ) = 34 ; 
flag( ceil( (A - D)/dy ), ceil((B+C)/dx ) ) = 43 ; 
flag( ceil( (A - D)/dy ), Nx ) = 34 ; 
flag ( Ny, Nx ) = 41 ; 
flag( ceil( (A/2-D/2)/dy)-1: ceil( (A/2+D/2)/dy ) , ceil ( (A/2-D/2)/dx)-1 : ceil( (A/2+D/2)/dx) ) = 20 ;
%%%%%%%%%%%%%%
%% przebieg symulacji %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_next = T ; 
heat(1) = 0 ;

for t=1:Nt
    for i=1:Ny
        for j=1:Nx
            switch flag(i,j)
                case 0
                    continue
                case 10
                T_next(i,j) = T(i,j) + K*dt / cw / ro / dx^2 * ( T( i+1,j ) - 2*T( i,j ) + T( i-1,j ) ) + ...
                    K*dt / cw / ro / dy^2 * ( T( i, j+1 ) - 2*T( i,j ) + T(i, j-1 ) ) ; 
                case 20
                T_next(i,j) = T(i,j) + dT + K*dt / cw / ro / dx^2 * ( T( i+1,j ) - 2*T( i,j ) + T( i-1,j ) ) + ...
                    K*dt / cw / ro / dy^2 * ( T( i, j+1 ) - 2*T( i,j ) + T(i, j-1 ) ) ; 
                case 1
                T_next(i,j) = T(i-1,j) ;
                 case 2
                T_next(i,j) = T(i,j+1) ;
                    case 3
                T_next(i,j) =T(i+1,j) ; 
                    case 4
                T_next(i,j) = T(i,j-1) ;
                    case 12
                T_next(i,j) = T(i-1,j+1);
                    case 23
                T_next(i,j) = T( i+1, j+1) ;
                    case 34
                T_next(i,j) = T(i+1, j-1 ) ; 
                    case 32
                T_next(i,j) = ( T(i+1,j)  + T(i,j +1) )/2 ; 
                    case 43
                T_next(i,j) = ( T(i,j-1)  + T(i+1,j) )/2 ; 
                    case 41
                T_next(i,j) = T(i-1,j-1) ; 
                    
                end
                    
            end
    end

  if sum( sum( (T_next - T).^2 )) < 0.0001
     break 
  end 
 T = T_next ; 
 
 for i=1:Ny
    for j=1:Nx
        if flag(i,j) == 0 
        else
            heat(t) = heat(t) + cw*ro*A^2/Nx/Ny * h*( T(i,j) - 20 ) ;
        end
    end
end
 
 

 if t*dt == 10  %%% po 10 sec wy³¹czamy grzanie czyli prze³¹czamy flagi w tych obszarach
     flag( ceil( (A/2-D/2)/dy)-1: ceil( (A/2+D/2)/dy ) , ceil ( (A/2-D/2)/dx)-1 : ceil( (A/2+D/2)/dx) )= 10 ;
 end
 if t*dt == 1000  %%% czas symulacji
      break 
 end
 heat = [heat, 0 ] ;


end

heat=heat(1:length(heat)-1) ;
plot( (1:length(heat))*dt,heat) ; 
 %% plotowanie wykresu
%[X, Y ] = contourf(x ,y , T_next , 100 ) ; 
%set(Y,'LineColor','none') ;  
%colormap( 'hot' ) ; 
%colorbar ; 
xlabel(' t [s] ' ) ; 
ylabel(' Heat [J] ' ) ;
title( strcat('dt =  ', num2str(dt), ' [s] ' )  ) ; 
%title( strcat('time = ', num2str(t*dt), ' [s] ' )  ) ; 
%pause(0.0001) ; 
saveas(gcf,'nowy.jpg')

