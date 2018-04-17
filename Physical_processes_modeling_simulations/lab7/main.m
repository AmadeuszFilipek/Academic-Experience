clc
clear

nazwa_plk = 'tryt_60.dat' ; 
skala =60 ;

roz = fopen( nazwa_plk  );
b = fscanf(roz,'%g', [ skala+1 inf]);
fclose(roz);



pole = b(1:1,:)./10000;
dane = b(2:( skala + 1 ) ,:)./10000;



%podzial na dane uczace i testujace 70/30(procentowo)

pole_ucz = pole(:,1: floor( length(pole)*0.7 ) );

dane_ucz = dane(:,1:floor( length(pole)*0.7 ) );



pole_test = pole(:,ceil( length(pole)*0.7 ):length(pole) ) ;

dane_test = dane(:,ceil( length(pole)*0.7 ):length(pole) ) ;


%%% 48 neuronow wejsciowych , 5 neuronow ukrytych, 1 wyjsciowy , traingdx,
%%% trainlm
algorytm = 'trainlm' ; 
net = newff(minmax(dane_ucz),[ skala 5 1 ],{'purelin','tansig','logsig'}, algorytm );

net.trainParam.epochs = 15 ;



net = train(net,dane_ucz,pole_ucz);



%sprawdzanie poprawnosci nauczenia sieci

y_test = sim(net,dane_test );

y_ucz = sim(net,dane_ucz  );


suma = 0 ; 

pole_test = pole_test * 10000 ; 
y_test = y_test * 10000 ; 
pole_ucz = pole_ucz * 10000 ; 
y_ucz = y_ucz * 10000 ; 

for i=1:length( pole_test ) 
    suma = suma + ( y_test(i) - pole_test(i) )^2 ; 
end
RMSE = sqrt( suma / length( pole_test ) )

%%%%%%%% wykresy %%%%%%%%%%%%%%%%%%%%%%%%%%
plot( 1:length(pole_ucz), log10(pole_ucz ) ) ; % log10
hold on ; 
plot( 1:length(pole_ucz), log10( y_ucz ) , 'r' ) ; 

plot( length(pole_ucz)+(1:length(pole_test) ), log10(pole_test ) ) ; 

plot(length(pole_ucz)+( 1:length(pole_test) ) , log10( y_test ) , 'r' ) ; 

title( [ 'algorytm ' algorytm ' RMSE = ' num2str(RMSE) ' [TU]' ] ) ; 
xlabel(' czas [miesiac]') ; 
ylabel( ' log Koncentracja Trytu [PU] ' ) ; 
saveas( gcf , [num2str(skala) '_lm' '.jpg']  ) ;

%%%%%%% jedynka na wejscie %%%%%%%%

one  = diag( ones(1,skala) , 0 ) ; 
Odp = sim(net, one ) ;
Odp = Odp  ; 
Tau = sum( (1:skala).*Odp ) / sum( Odp ) 






