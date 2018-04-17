clc
clear 

czas = load('lab5_piat1620.txt') ; % macierz czasowowa procesor/zadanie
proc = length( czas(:,1) ) ; % ilosc posiadanych procesorow
job = length( czas(1,:) ) ; % ilosc zadan do wykonania 
N = 1000 ; % iteracji
T_zero = 100 ; % temp poczatkowa 

wyniki = zeros(1,20) ; 
for K = 1:20
    
koszt = inf(1,N) ;
T = T_zero * ones(1,N) ; 

Rozwiazanie = zeros( proc , job , N ) ; % wektor macierzy rozwiazan
% jesli jest 1 to procesor i, wykonuje zadanie y, jesli 0 to nie wykonuje

%% losowa inicjalizacja
%dla kazdego zadania losujemy jeden procesor
for j = 1:job
    rnd_proc = random('Unid' , proc) ;
Rozwiazanie( rnd_proc , j , 1) = 1 ;  
end

%% obliczenie pierwszego kosztu
 sumy = zeros(1, proc ) ; 
 
    for p = 1:proc

        [r,c,d] = find( Rozwiazanie( p ,: ,1) == 1 ) ; 
        sumy(p) = sum( czas(p, c ) ) ;  
    end

    koszt(1) = max( sumy );


%% main loop

for i=1:N-1
    %% generacja rozwiazania sasiedniego
    % losujemy zadanie, i temu zadaniu losujemy nowy procesor
    for Z = 1:1
    rnd_job = random('Unid' , job) ;
    
    % losujemy procesor rozny od starego
    while 0 == 0
        rnd_proc = random('Unid' , proc) ;
        Rozwiazanie(: , :, i+1) = Rozwiazanie(:, :, i) ;
        [r,c,d] = find( Rozwiazanie(:,rnd_job,i) == 1 ) ;  
        %sprawdzamy czy nowy procesor != stary procesor
        if r(1) ~= rnd_proc
           
            break
        end
    end
   
    % zamiana zadan dla procesorow
    Rozwiazanie( r(1) , rnd_job  ,i+1) = 0 ;
    Rozwiazanie(rnd_proc ,rnd_job  , i+1) = 1 ; 
    end

    % obliczanie funkcji kosztu 
    %dla kazdego procesora nale¿y wysumowaæ czasy zadan

    sumy = zeros( 1, proc ) ; 
    for p = 1:proc

        [r,c,d] = find( Rozwiazanie( p ,: ,i) == 1 ) ; 
        sumy(p) = sum( czas(p, c ) ) ;  
    end

    koszt(i+1) = max( sumy );

    %% na podstawie kosztu nalezy zweryfikowac czy zmiana nastepuje czy nie
    % procedura metropolisa, jesli koszt spada i jesli losowa U(0,1) jest
    % mniejsza niz eksp. z temperatury to rozwiazanie sie nie zmienia.
    if koszt(i+1) < koszt(i)
        if random('Uniform',0,1) < exp( (koszt(i) - koszt(i+1) )/ T(i)) ;
        else
            Rozwiazanie(:,:,i+1) = Rozwiazanie(:,:,i) ; 
        end
    end
    
    T(i+1) = T_zero/(i+1) ; 
    best(i) = min(koszt) ; 
     
end


wyniki(K) = min(koszt) ;

end 

srednie = mean(wyniki)
odch_std = std(wyniki)

plot(best, 'red') ;
xlabel('Iteracja') ; 
ylabel('Funkcja kosztu'); 
hold on; 
plot( koszt ) ;


