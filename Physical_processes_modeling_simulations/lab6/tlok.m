clc
clear

Data = load ( 'tryt.txt' ) ; 

Data = Data( :, 2:3) ; 
time = 1:length(Data(:,1) ) ; % kolejne miesiace pomiaru
Opad = Data(:,1) ; 
Dunajec = Data( 118:length(Data(:,1)) , 2) ;  % 118 miesiac to poczatek danych pomiarowych wyjscia rzeki

%%%%%%%%%%%%%%%%%% czyszczenie brakujacych danych ( -9999 ) %%%%%%%%%%%%%%%
Dunajec_clean  = [] ; 
time_clean = [] ; 
temp_1 = Data ( 1 , 1 ) ; 
temp_2 = 0 ;
flag = 1 ;
inter_lenght = 1 ;

for i=1:length( Dunajec )
    
    if Dunajec(i)<(-9998)
    
    else
    Dunajec_clean = [ Dunajec_clean ; Dunajec(i) ] ;
    time_clean = [ time_clean ; i + 117 ] ; 
    end
end

% cftool( time_clean, Data_clean ) ; wypelnic reszte danych czasowych

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% obliczenie splotu %%%%%%%%%%%%%%%%%%%

blad = [] ; 
lambda = log(2)/ 12.3/12 ; % 1 / miesiac 

for q = 1:10:500
Tau = q ; % miesiecy
stezenie = [] ;

for i=1:length(Opad) 
    sum = 0 ;
    if i<=Tau
        sum = 0 ;
    else
        sum = sum + Opad(i-Tau) * exp( -lambda*Tau ) ;          
    end
    
    stezenie = [ stezenie sum ] ; 
end
        
%%%%%%%%%%%%  obliczenie RMSE %%%%%%%%%%%%%%
sum = 0 ; 
L = 0;
for i = 1:length( time_clean ) 
    if   stezenie( time_clean(i) )==0
        sum = 0
    else
  sum = sum + ( stezenie( time_clean(i) ) - Dunajec_clean(i) )^2 ; 
  L = L + 1 ;
    end
end

RMSE = sqrt( sum/ L ) ; 
blad = [ blad RMSE ] ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end 

%plot( time , stezenie ) ; 
%hold on ; 
%plot ( time_clean,  Dunajec_clean , 'r') ; 

plot( 1:10:500, blad ) ; 
title( 'model tlokowy' ) ; 
xlabel(' Tt [ miesiac ] ') ; 
ylabel( ' RMSE [ TU ] ' ) ; 

saveas(gcf , '1_500tlok.jpg' )  ;