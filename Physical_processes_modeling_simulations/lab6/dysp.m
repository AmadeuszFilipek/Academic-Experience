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

blad = zeros(15,500) ; 
lambda = log(2)/ 12.3/12 ; % 1 / miesiac 
for p = 1:15
Pe = p ;
for q =1:10:500
Tau = q ; % miesiecy
stezenie = [] ;

for i=1:length(Opad) 
    sum = 0 ;
    for j=1:(i-1)
        
        sum = sum + Opad(j) * (4*pi*Pe*(i-j)/Tau )^(-1/2)/(i-j)*exp( - (1-(i-j)/Tau)^2/4/Pe/(i-j)*Tau ) * exp( -lambda*(i-j) ) ;     
        
    end
    stezenie = [ stezenie sum ] ; 
end
        
%%%%%%%%%%%%  obliczenie RMSE %%%%%%%%%%%%%%
sum = 0 ; 
for i = 1:length( time_clean ) 
  sum = sum + ( stezenie( time_clean(i) ) - Dunajec_clean(i) )^2 ; 
end

RMSE = sqrt( sum/ length(time_clean) ) ; 
blad(p,q) = RMSE ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end  

end
%plot( time , log10( stezenie ) ) ; 
%hold on ; 
%plot ( time_clean, log10( Dunajec_clean ), 'r') ; 

%title( 'model dyspersyjny' ) ; 
%xlabel(' Czas [ miesiac ] ') ; 
%ylabel( ' log Koncentracji trytu [ TU ] ' ) ; 

%saveas(gcf , 'dysp_3Pe.jpg' )  ;

contourf(1:10:500 ,1:15 , blad , 100 ) ; 

%plot( 1:10:300 , blad ) ; 
title( 'model dyspersyjny' ) ; 
xlabel(' Liczba Pecleta ') ; 
ylabel( ' RMSE [ TU ] ' ) ; 

saveas(gcf , '1_10dysp_Pe_test3.jpg' )  ;