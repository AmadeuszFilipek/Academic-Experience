clear
clc

N_ucz = 100 ;
N_test = 500 ; 

x_ucz1 = mvnrnd([0 0], [1 0; 0 1], N_ucz ) ; 
x_ucz2 = mvnrnd([3 0], [1 0; 0 1], N_ucz ) ;

y_ucz1 = zeros(N_ucz,1) ;
y_ucz2 = ones(N_ucz,1) ;

x_ucz = [ x_ucz1; x_ucz2 ] ; 
y_ucz = [ y_ucz1; y_ucz2 ] ;

x_test1 = mvnrnd([0 0], [1 0; 0 1], 500 ) ; 
x_test2 = mvnrnd([3 0], [1 0; 0 1], 500 ) ;

y_test1 = zeros(500,1) ;
y_test2 = ones(500,1) ;

x_test = [ x_test1; x_test2 ] ; 
y_test = [ y_test1; y_test2 ] ;

net = perceptron(); 
net.trainParam.epochs = 300 ; 
net = train(net, x_ucz' , y_ucz' ) ; 

%% wynik zbioru uczacego
wy_ucz = net( x_ucz' ) ; 
blad_ucz = sum( (wy_ucz-y_ucz').^2 ) / N_ucz/2 ; 

%% wynik zbioru testujacego
wy_test = net ( x_test' ) ; 
blad_test = sum( (wy_test-y_test').^2 ) /N_test/2 ;  

%% macierze pomylek 

macierz_pom_ucz = zeros(2,2) ; 
macierz_pom_test = zeros(2,2) ; 

macierz_pom_ucz(1,1) = N_ucz - sum( net( x_ucz1' ) ) ;
macierz_pom_ucz(1,2) = sum( net( x_ucz1' ) ) ;
macierz_pom_ucz(2,1) = N_ucz - sum( net( x_ucz2' ) ) ; 
macierz_pom_ucz(2,2) = sum( net( x_ucz2' ) ) ; 

macierz_pom_test(1,1) = N_test - sum( net( x_test1' ) ) ;
macierz_pom_test(1,2) = sum( net( x_test1' ) ) ;
macierz_pom_test(2,1) = N_test - sum( net( x_test2' ) ) ; 
macierz_pom_test(2,2) = sum( net( x_test2' ) ) ; 

%% plotowanie wyniku uczacego

gscatter( x_ucz(:,1), x_ucz(:,2), y_ucz ) ; 
hold on ;
x = -3:0.1:3;
a = - net.iw{1,1}(1)/net.iw{1,1}(2) ; 
b = - net.b{1}/net.iw{1,1}(2) ;
y = a * x + b  ;

  plot(x,y,'-');
legend('Klasa 0', 'Klasa 1', 'Prosta podzia³u');
str = ['y = ' num2str(a) 'x + ' num2str(b)];
text( 2.0,-3, str);
xlabel('cecha 1');
ylabel('cecha 2');
xlim([-4 7]) ; 
ylim([-4 4]) ; 
hold off;
    
%% plotowanie wyniku testujacego

gscatter( x_test(:,1), x_test(:,2), y_test ) ; 
hold on ;
x = -3:0.1:3;
a = - net.iw{1,1}(1)/net.iw{1,1}(2) ; 
b = - net.b{1}/net.iw{1,1}(2) ;
y = a * x + b ;
  plot(x,y,'-');
  
legend('Klasa 0', 'Klasa 1', 'Prosta podzia³u');
str = ['y = ' num2str(a) 'x + ' num2str(b)];
text( 2.0,-3, str);
xlabel('cecha 1');
ylabel('cecha 2');
xlim([-4 7]) ; 
ylim([-4 4]) ; 
hold off;
