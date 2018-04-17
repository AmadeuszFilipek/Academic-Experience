clc
clear

P = 40 ; % licznosc osobnikow w roju
epoch = 100 ; % ilosc epok 
c_1 = 1 ; % parametry akceleracji
c_2 = 1 ; 
tlok = 0 ; % wspolczynnik scisku 0 - bez, 1 = uwzgledniony

x_min = -10 ; 
x_max = 10 ;
y_min = -10 ; 
y_max = 10 ; 

v_max = 10 ; 
v_min = - v_max ; 

%inicjalizacja roju

wyniki = zeros(1, 20 ) ; 
x_best = zeros(1, 20 ) ; 
y_best = zeros(1, 20 ) ; 

for N = 1:20

x_pop = random('Uniform',-10,10 ,P, epoch +1);
y_pop = random('Uniform',-10,10 ,P, epoch +1);

v_x_pop = random('Uniform',-10,10 ,1, P ); % zeros
v_y_pop = random('Uniform',-10,10 ,1, P ); % zeros

cel = inf(P, epoch) ; 

for i=1:epoch 
    
    cel(:,i) = funkcja_celu( x_pop(:,i), y_pop(:,i) ) ;
    [r,c,v] = find( cel == min(min(cel)) ) ; 
    global_best_x = x_pop( r(1), c(1) ) ;
    global_best_y = y_pop( r(1), c(1) ) ;
    
    for p=1:P
        
    [r,c,v] = find( cel(p,:) == min(cel(p,:)) ) ; 
    p_best_x = x_pop( p, c(1) ) ;
    p_best_y = y_pop( p, c(1) ) ;
    
    v_x_pop(p) = v_x_pop(p) + random('Uniform',0,c_1)*( p_best_x - x_pop(p,i) )+ ...
        random('Uniform',0,c_2)*( global_best_x - x_pop(p,i) ) ; 
    v_y_pop(p) = v_y_pop(p) + random('Uniform',0,c_1)*( p_best_y - y_pop(p,i) )+ ...
        random('Uniform',0,c_2)*( global_best_y - y_pop(p,i) ) ; 
    
    if ( tlok ~= 0 )
    w = 2/( 2 + sqrt( (c_1+c_2)^2 - 4*(c_1+c_2) ) ) ; 
    v_x_pop(p) = v_x_pop(p) * w ; 
    v_y_pop(p) = v_y_pop(p) * w ; 
    end
    
    %% test czy predkosc nie wykracza po za zakres
      if ( tlok == 0 )
            if( v_x_pop(p) > v_max | v_x_pop(p) < v_min )
                v_x_pop(p) = v_max * sign( v_x_pop(p) ) ;
            end

            if( v_y_pop(p) > v_max | v_y_pop(p) < v_min )
                v_y_pop(p) = v_max * sign( v_y_pop(p) ) ;
            end
      end
    %% obliczenie polozen nastepnego kroku  
    x_pop(p,i+1) =  v_x_pop(p) + x_pop(p,i) ;
    y_pop(p,i+1) =  v_y_pop(p) + y_pop(p,i) ; 
    
    %% test czy polozenia nie wykroczyly poza zakres, jesli tak to sie odbijaja
    if( x_pop(p,i+1) > x_max )
       x_pop(p,i+1) = x_pop(p,i+1) - v_x_pop(p) ;   
       v_x_pop(p) = - v_x_pop(p) ;  
    end
    if( x_pop(p,i+1) < x_min )
        x_pop(p,i+1) = x_pop(p,i+1) - v_x_pop(p) ;   
        v_x_pop(p) = - v_x_pop(p) ; 
    end
    
    if( y_pop(p,i+1) > y_max )
        y_pop(p,i+1) = y_pop(p,i+1) -  v_y_pop(p) ;   
        v_y_pop(p) = - v_y_pop(p) ; 
        
    end
    
    if( y_pop(p,i+1) < y_min ) 
        y_pop(p,i+1) = y_pop(p,i+1) -  v_y_pop(p) ;
        v_y_pop(p) = - v_y_pop(p) ; 
    end
    
  end
  % plot( x_pop(:,i) , y_pop(:,i) , '*' )
  % plot( i , global_best_x , '*') 
  % hold on
  % pause(0.01)
end

  wyniki(N) = min( min(cel) ) ; 
  x_best(N) =  global_best_x ;
  y_best(N) =  global_best_y ; 
  
end

mean( wyniki )
std( wyniki ) 

plot( 1:epoch, mean(cel) ) ; 
xlabel('epoka'); 
ylabel('œrednie przystosowanie populacji'); 

plot( 1:epoch, std(cel) ) ; 
xlabel('epoka'); 
ylabel('odchylenie std. przystosowania'); 

plot( 1:epoch, min(cel) ) ; 
xlabel('epoka'); 
ylabel('Przystosowanie najlepszego osobnika'); 

xplot = x_min:0.1:x_max;
yplot = y_min:0.1:y_max;
[xplot, yplot] = meshgrid(xplot, yplot);
figure;
contourf(xplot, yplot, funkcja_celu(xplot, yplot), 10); % surf
xlabel('x');
ylabel('y');
zlabel('f(x,y)');    
colormap autumn;     
c = colorbar ; 
ylabel(c,'f(x,y)') ; 
hold on; 
plot( x_best, y_best, '*' ) ; 
    