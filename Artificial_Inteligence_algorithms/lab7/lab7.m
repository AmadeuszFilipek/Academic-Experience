clc
clear

in_MF_Type = 'gbellmf' ;% typ funkcji przynaleznosci dla wejsc
out_MF_Type = 'linear' ;% typ funkcji przynaleznosci dla wyjscia
epoch = 20 ;% epoki trenowania ukladu
num_MF = 3 ; % ziarnistosc, ilosc funkcji przynaleznosci dla kazdego wejscia
train_Ratio = 0.9 ;
test_Ratio = 1 - train_Ratio ; 


data = load( 'lab02_data.mat' ) ;
[ index_Train , index_Val, index_Test ] = dividerand( length(data.x(:,1)), train_Ratio, 0 , test_Ratio) ;

data_Train = data.x(index_Train, : ) ;

data_Test = data.x(index_Test, :) ;

%%%%%%%%5
%fuzzy_System = genfis1( data_Train, num_MF, in_MF_Type, out_MF_Type ) ; 
%fuzzy_System = genfis2( data_Train(:,1:3), data_Train(:,4), [0.2 0.2 0.2 0.2] ) ; 
fuzzy_System = genfis3( data_Train(:,1:3), data_Train(:,4), 'sugeno', 25  ) ; 

fuzzy_System = anfis( data_Train, fuzzy_System, epoch ) ; 

out_Train = evalfis( data_Train(:,1:3) , fuzzy_System ) ; 
out_Test = evalfis( data_Test(:,1:3), fuzzy_System ) ; 

train_Ratio 
num_MF
epoch
blad_Train = sum(( out_Train - data_Train(:,4) ).^2) / length(out_Train)
blad_Test = sum( (out_Test - data_Test(:,4)).^2 ) / length( out_Test)


%%%%%%%%%%%%
% plotowanie
% x1
%  plot( data_Train(:,1), data_Train(:,4), 'bo' ) ; 
%  hold on
% plot( data_Train(:,1), out_Train, 'ro' ) ;  
%  plot( data_Test(:,1), out_Test, 'go' ) ; 
% % x2
% plot( data_Train(:,2), data_Train(:,4), 'bo' ) ; 
% hold on
% plot( data_Train(:,2), out_Train, 'ro' ) ; 
% plot( data_Test(:,2), out_Test, 'go' ) ; 
% % x3
% plot( data_Train(:,3), data_Train(:,4), 'bo' ) ; 
% hold on
% plot( data_Train(:,3), out_Train, 'ro' ) ; 
% plot( data_Test(:,3), out_Test, 'Bo' ) ; 