clear all
clc

roz = fopen('tryt_48.dat');
b = fscanf(roz,'%g', [49 inf]);
fclose(roz);



pole = b(1:1,:)./10000;
dane = b(2:49,:)./10000;



%podzial na dane uczace i testujace 70/30(procentowo)

pole_ucz = pole(:,1:300);

dane_ucz = dane(:,1:300);



pole_test = pole(:,301:408);

dane_test = dane(:,301:408);


%%% 48 neuronow wejsciowych , 5 neuronow ukrytych, 1 wyjsciowy , traingdx,
%%% trainlm
net = newff(minmax(dane_ucz),[48 5 1],{'purelin','tansig','logsig'},'traingdx');

net.trainParam.epochs = 1000;



net = train(net,dane_ucz,pole_ucz);



%sprawdzanie poprawnosci nauczenia sieci

y_test = sim(net,dane_test);

y_ucz = sim(net,dane_ucz);

pause(.01)



%wykres Y(z)

subplot(1,1,1);

plot(pole_test,y_test,'+b',pole_ucz,y_ucz,'*r');





%subplot(3,1,3);

%[AX H1 H2]=plotyy(pole_ucz,y_ucz,pole_test,y_test);

%set(H1,'LineStyle','*');

%set(H2,'LineStyle','+');

