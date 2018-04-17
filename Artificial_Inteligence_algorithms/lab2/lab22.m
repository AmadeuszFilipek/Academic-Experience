clear
clc

lab_train = load('Lab2_training.txt') ;

x_ucz = lab_train(:, 1:4)' ;
y_ucz = lab_train(:, 5:7)' ; 

lab_testing = load('Lab2_testing.txt') ;
x_test = lab_testing(:, 1:4)' ;
y_test = lab_testing(:, 5:7)' ; 

net = feedforwardnet(20) ; 
net.divideFcn = 'dividetrain' ;

%% help nntransfer
net.layers{1}.transferFcn = 'hardlim' ; 
net.trainParam.epochs = 200 ; 

net = train(net, x_ucz, y_ucz) ; 

%% blad sieci, konwersja wyniku
out_ucz = net(x_ucz) ;
flag = zeros( 1, length( out_ucz(1,:) ) ) ;

for i = 1:length( out_ucz(1,:) )
    if out_ucz(1,i) >= out_ucz(2,i)
        if out_ucz(1,i) > out_ucz(3,i)
            flag(i) = 1 ; 
        else
            flag(i) = 3 ; 
        end
    else
        if out_ucz(2,i) > out_ucz(3,i)
            flag(i) = 2 ; 
        else
            flag(i)= 3 ; 
        end
    end
end

out_ucz = flag ; 

%% konwersja danych wejsciowych uczacych
flag = zeros( 1, length( y_ucz(1,:) ) ) ;

for i = 1:length( y_ucz(1,:) )
    if y_ucz(1,i) >= y_ucz(2,i)
        if y_ucz(1,i) > y_ucz(3,i)
            flag(i) = 1 ; 
        else
            flag(i) = 3 ; 
        end
    else
        if y_ucz(2,i) > y_ucz(3,i)
            flag(i) = 2 ; 
        else
            flag(i)= 3 ;  
        end
    end
end

y_ucz = flag ; 

blad_ucz = 0 ; 
for i=1:length( y_ucz ) 
    if y_ucz(i) ~= out_ucz(i)
        blad_ucz = blad_ucz + 1 ; 
    end
end
blad_ucz = blad_ucz / 130

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% konwersja danych testujacych

flag = zeros( 1, length( y_test(1,:) ) ) ;

for i = 1:length( y_test(1,:) )
    if y_test(1,i) >= y_test(2,i)
        if y_test(1,i) > y_test(3,i)
            flag(i) = 1 ; 
        else
            flag(i) = 3 ; 
        end
    else
        if y_test(2,i) > y_test(3,i)
            flag(i) = 2 ; 
        else
            flag(i)= 3 ; 
        end
    end
end

y_test = flag ; 
%% konwersja danych wynikowych dla zbioru testujacego
out_test = net(x_test) ; 
flag = zeros( 1, length( out_test(1,:) ) ) ;

for i = 1:length( out_test(1,:) )
    if out_test(1,i) >= out_test(2,i)
        if out_test(1,i) > out_test(3,i)
            flag(i) = 1 ; 
        else
            flag(i) = 3 ; 
        end
    else
        if out_test > out_test(3,i)
            flag(i) = 2 ; 
        else
            flag(i)= 3 ; 
        end
    end
end

out_test = flag ; 

blad_test = 0 ; 
for i=1:length( y_test ) 
    if y_test(i) ~= out_test(i)
        blad_test = blad_test + 1 ; 
    end
end
blad_test = blad_test / 18

