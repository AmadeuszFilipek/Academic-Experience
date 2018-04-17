clear
clc

N = 100 ;
M = 1000 ;

x_ucz = random('Uniform',-3,3,2,100) ;
y_ucz = peaks(x_ucz(1,:) , x_ucz(2,:) ) ; 

x_test = random('Uniform',-3,3,2,1000) ;
y_test = peaks(x_test(1,:) , x_test(2,:) ) ; 

net = feedforwardnet(20) ; 
net.divideFcn = 'dividetrain' ;
%% help nntransfer
net.layers{1}.transferFcn = 'tansig' ; 
net.trainParam.epochs = 200 ; 

net = train(net, x_ucz, y_ucz) ; 

%% blad sieci


out_ucz = net(x_ucz) ; 
rmse_ucz = 1/N * sum(( out_ucz - y_ucz ).^2 )

out_test = net(x_test) ; 
rmse_test = 1/M * sum(( out_test - y_test ).^2 )

%% plotowanie funkcji powierzchni

ti = -2:.1:2;
[XI,YI] = meshgrid(ti,ti);
ZI = griddata(x_test(1,:),x_test(2,:),y_test,XI,YI , 'v4');



surf(XI,YI,ZI);
xlabel('x1') ; 
ylabel('x2') ; 
zlabel('f(x1,x2)') ; 

ZI = griddata(x_test(1,:),x_test(2,:),out_test,XI,YI , 'v4');
%surf(XI,YI,ZI);





