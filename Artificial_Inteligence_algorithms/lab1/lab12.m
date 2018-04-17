clear
clc

data = load('Lab1_training.txt') ; 
x_ucz = data(:,1:3) ; 
y_ucz = data(:,4) ; 


net = perceptron(); 
net.trainParam.epochs = 1 ;
net = train(net, x_ucz' , y_ucz' ) ;
net.iw{1,1}(1) = random('unif', -1,1 , 1,1) ;

net.trainParam.epochs = 1000 ;
net.iw{1,1}(2) = random('unif', -1,1 , 1,1) ;
net = train(net, x_ucz' , y_ucz' ) ; 


%% wynik zbioru uczacego
wy_ucz = net( x_ucz' ) ; 
blad_ucz = sum( (wy_ucz-y_ucz').^2 ) / length( y_ucz' ) ;

macierz_blad = zeros(2,2) ; 

for i = 1:length(y_ucz)
    if wy_ucz(i) ~= y_ucz(i)
        if y_ucz(i)== 0 
            macierz_blad(1,2) = macierz_blad(1,2) + 1 ;
        else
             macierz_blad(2,1) = macierz_blad(2,1) + 1 ;
        end
    else
        if y_ucz(i)== 0 
            macierz_blad(1,1) = macierz_blad(1,1) + 1 ; 
        else
             macierz_blad(2,2) = macierz_blad(2,2) + 1 ;
        end
    end
end



%% plotowanie wyniku uczacego

gscatter( x_ucz(:,2), x_ucz(:,2), y_ucz ) ; 
hold on ;
x = -3:0.1:3;
y = -x * net.iw{1,1}(1)/net.iw{1,1}(2) - net.b{1}/net.iw{1,1}(2) ;

    plot( x,y )
    