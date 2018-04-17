clc 
clear
clf

N = 1000 ; % ilosc czasteczek
M = 1000 ; % ilosc krokow czasowych

x = zeros(N,M) ;
y = zeros(N,M) ;
r = zeros(N,M) ;

delta = 4 ;  % szerokosc binow
bins = 2:delta:100 ; 

for i=1:N      % dla kazdej czastki
     
    for j=2:M         % kolejne kroki czasowe
    x(i,j) = x(i,j-1) + randn ;
    y(i,j) = y(i,j-1) + randn ; 
    r(i,j) = sqrt( x(i,j)^2 + y(i,j)^2 ) ;
    end
   
end
 
[bin_count , bin_possition ]  = hist( r(:, M ) , bins ) ;        % generowanie histogramu 
    
  for i=1:length( bin_count ) 
        bin_count(i) = bin_count(i) /( 2 * pi * delta * bin_possition(i) ) ; % normowanie do pola powierzchni
  end
bar( bin_possition, bin_count , 1 ,'g' ) ;             % rysowanie wykresu
xlabel( ' r' ) ; 
ylabel( ' Density of counts ' ) ; 
