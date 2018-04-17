clc;
clear;

%% z tablicy
% help nntransfer -> funkcje aktywacji
% peaks(2,1); -> wykres
% unifrnd -> rozklad jednorodny
% x1 = [x11 x12] z przedzialu [-3 do 3]
% caly zbior uczacy do treningu, bez podzialu na test, valid i train
% dla najlepszej konfiguracji sieci z roznymi f. aktywacji i liczba
% neuronow policzyc blad na zbiorze testujacym i porownac z siecia o
% liczbie neuronow = 10
% blad MSE_test = 1/m * sum(yi - yi)^2
% dla kazdego przypadku taka sama liczba epok
% griddata()

%% aproksymacja
clc;
clear;

% wygenerowanie wejscia
ileucz = 100;
iletest = 1000;

Xucz = unifrnd(-3,3, 2,ileucz);
% Yucz = 3 * (1 - Xucz(1,:)).^2 .* exp(-(Xucz(1,:).^2) - (Xucz(2,:) + 1).^2) - 10 .* (Xucz(1,:)./5 - Xucz(1,:).^3 - Xucz(2,:).^5) .* exp(-Xucz(1,:).^2 - Xucz(2,:).^2) - 1/3 .* exp(-(Xucz(1,:) + 1).^2 - Xucz(2,:).^2);
Yucz = peaks(Xucz(1,:), Xucz(2,:));

Xtest = unifrnd(-3,3, 2,iletest);
% Ytest = 3 * (1 - Xtest(1,:)).^2 .* exp(-(Xtest(1,:).^2) - (Xtest(2,:) + 1).^2) - 10 .* (Xtest(1,:)./5 - Xtest(1,:).^3 - Xtest(2,:).^5) .* exp(-Xtest(1,:).^2 - Xtest(2,:).^2) - 1/3 .* exp(-(Xtest(1,:) + 1).^2 - Xtest(2,:).^2);
Ytest = peaks(Xtest(1,:), Xtest(2,:));

% stworzenie sieci
ile_neuronow = [25 50 75];
funkcje_akt = {'hardlims', 'purelin', 'tansig'};

MSE_mac_ucz = cell(4,4);
MSE_mac_ucz(1,2:4) = funkcje_akt;
MSE_mac_ucz(2:4,1) = num2cell(ile_neuronow');

MSE_mac_test = cell(4,4);
MSE_mac_test(1,2:4) = funkcje_akt;
MSE_mac_test(2:4,1) = num2cell(ile_neuronow');

for i = 1:length(ile_neuronow)
    for j = 1:length(funkcje_akt)
        net = feedforwardnet(ile_neuronow(i));
        net.divideFcn = 'dividetrain';
        net.layers{1}.transferFcn = funkcje_akt{j};
        net.trainParam.epochs = 100;
        %configure(net, Xucz, Yucz);
        %view(net);

        % trenowanie sieci
        net = train(net, Xucz, Yucz);

        % obliczenie bledu
        Y = net(Xucz);
        MSE_mac_ucz{i+1,j+1} = (1 / ileucz) * sum((Yucz - Y).^2);
        
        Y = net(Xtest);
        MSE_mac_test{i+1,j+1} = (1 / iletest) * sum((Ytest - Y).^2);
    end
end

% rysowanie wykresu
% zbior uczacy
net = feedforwardnet(75);
net.divideFcn = 'dividetrain';
net.layers{1}.transferFcn = 'tansig';
net.trainParam.epochs = 100;
net = train(net, Xucz, Yucz);
Y = net(Xucz);

ti = -2:0.1:2;
[XI, YI] = meshgrid(ti, ti);
ZI = griddata(Xucz(1,:), Xucz(2,:), Y, XI, YI, 'v4');
figure;
surf(XI, YI, ZI);
xlabel('X_1');
ylabel('X_2');
zlabel('Y');

% rzeczywista funkcja
ti = -2:0.1:2;
[XI, YI] = meshgrid(ti, ti);
ZI = griddata(Xucz(1,:), Xucz(2,:), Yucz, XI, YI, 'v4');
figure;
surf(XI, YI, ZI);
xlabel('X_1');
ylabel('X_2');
zlabel('Y');

% zbior testujacy
net = feedforwardnet(25);
net.divideFcn = 'dividetrain';
net.layers{1}.transferFcn = 'tansig';
net.trainParam.epochs = 100;
net = train(net, Xucz, Yucz);
Y = net(Xtest);

ti = -2:0.1:2;
[XI, YI] = meshgrid(ti, ti);
ZI = griddata(Xtest(1,:), Xtest(2,:), Y, XI, YI, 'v4');
figure;
surf(XI, YI, ZI);
xlabel('X_1');
ylabel('X_2');
zlabel('Y');

% rzeczywista funkcja
ti = -2:0.1:2;
[XI, YI] = meshgrid(ti, ti);
ZI = griddata(Xtest(1,:), Xtest(2,:), Ytest, XI, YI, 'v4');
figure;
surf(XI, YI, ZI);
xlabel('X_1');
ylabel('X_2');
zlabel('Y');


%% klasyfikacja
clc; 
clear;

dane_ucz = load('Lab2_training.txt');
dane_test = load('Lab2_testing.txt');

Xucz = dane_ucz(:,1:4)';
Yucz = dane_ucz(:,5:7)';

Xtest = dane_test(:,1:4)';
Ytest = dane_test(:,5:7)';

% funkcje_akt = {'logsig', 'hardlims'};
ile_neuronow = 10:10:100;

MSE_mac_ucz = zeros(length(ile_neuronow), 2);
MSE_mac_ucz(:,1) = ile_neuronow';

MSE_mac_test = zeros(length(ile_neuronow), 2);
MSE_mac_test(:,1) = ile_neuronow';

for i = 1:length(ile_neuronow)
    net = feedforwardnet(ile_neuronow(i));
    net.divideFcn = 'dividetrain';
    net.layers{1}.transferFcn = 'logsig';
    net.trainParam.epochs = 100;

    net = train(net, Xucz, Yucz);

    Y = net(Xucz);
    
%     for j = 1:length(Y(1,:))
%         ind = find(Y(:,j) == max(Y(:,j)));
%         Y(:,j) = [0; 0; 0;];
%         Y(ind,j) = 1;
%     end
%     
%     MSE_mac_ucz(i,2) = (1 / length(Y)) * sum(sum((Yucz - Y).^2));
    MSE_mac_ucz(i,2) = mse(Yucz - Y);
    
    Y = net(Xtest);
    
%     for j = 1:length(Y(1,:))
%         ind = find(Y(:,j) == max(Y(:,j)));
%         Y(:,j) = [0; 0; 0;];
%         Y(ind,j) = 1;
%     end
%     
%     MSE_mac_test(i,2) = (1 / length(Y) / 2) * sum(sum((Ytest - Y).^2));
    MSE_mac_test(i,2) = mse(Ytest - Y);

end