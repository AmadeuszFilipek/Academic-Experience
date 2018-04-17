clc 
clear
clf

N = 1000 ;  % ilosc czasteczek
M = 800 ;  % ilosc krokow czasowych

x = zeros(N,M) ; 
y = zeros(N,M) ;
bins1 = -100:10:100 ;
bins = {bins1 bins1} ; 

for i=1:N          % powtarzane dla kazdej czasteczki
    
    for j=2:M      % dla kazdego kroku czasowego
    x(i,j) = x(i,j-1) + randn ;
    y(i,j) = y(i,j-1) + randn ;  
    end
    
   %hist3( [x(:,ceil(i*M/N) ) y(:,ceil(i*M/N) )] , bins ) ;
   %pause(0.01) ; 
end

hist3( [x(:,M ) y(:,M )] , bins ) ;                         % rysowanie histogramu
set(gcf, 'render','opengl' ) ; 
   set(get(gca,'child'),'FaceColor','interp','CDataMode', 'auto');
   colormap( hot ) ;
%[ bin_count,  bin_possition ] = hist( x(:, M ) , bins1 ) ;
%h = bar( bin_possition, bin_count , 1) ; 
%h = plot( x(3,:),y(3,:) ) ;
%xlabel('x') ; 
%ylabel('y' ) ;

