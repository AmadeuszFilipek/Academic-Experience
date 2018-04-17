clear
clc

N = 22 ; % rozdzielczosc bitowa przedzialu
P = 20 ; % licznosc populacji, licznosc rozwiazan
epoch = 100 ; % 100 epok iteracji algorytmu
p_cross = 0.7 ; % p-stwo krzyzowania
Cross = p_cross * P ; % ilosc krzyzowanych osobnikow
p_mut = 0.1 ; % p-stwo mutacji
gray = 0 ; % kod greja czy zwykly

x_opt = zeros(1,20) ; 

for proba = 1:20

populacja = random('bino',1,0.5,N,P) ;

populacja_nowa = zeros(N,P) ; 
ocena = zeros(P,100) ; 
przystosowania = 0 ; 
pola = 0 ; 
biny = zeros(1,21) ; 

for i=1:epoch
    %% ocena populacji %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for p=1:P
    ocena(p,i) = funkcja(populacja(:,p), gray) ;
    end
    
    %% selekcja metoda ruletki %%%%%%%%%%%%%%%%%%%%%%%%%%%
   	przystosowania =  ocena(:,i) ;
    przystosowania =  przystosowania + 2*abs( min(przystosowania) ); 
    pola = przystosowania / sum(przystosowania) ;
    for el=2:P+1
        biny(el) = sum( pola(1:el-1) ) ;
    end
    for shoot=1:P
        rand = random('Uniform',0,1); 
        for k=1:P
            if rand > biny(k) && rand < biny(k+1)
            populacja_nowa(:,shoot) = populacja(:,k) ;
            break
            end
        end
    end
    %% krzyzowanie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rand = randperm(P, Cross) ; 
    for elem=1:Cross/2
       locus = random('unid',N) ;
       temp = populacja_nowa(locus:N,rand(elem) ) ;
       populacja_nowa(locus:N,rand(elem) ) = populacja_nowa(locus:N,rand(elem+Cross/2) ) ; 
       populacja_nowa(locus:N,rand(elem+Cross/2) ) = temp ; 
    end
    %% mutacja %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for mut=1:p_mut*P*N
        rand = random('unid',P) ;
        rand2 = random('unid',N) ;
        populacja_nowa(rand2, rand) =  ~ populacja_nowa(rand2, rand) ;
    end
        
populacja = populacja_nowa ;
end
    
%% weryfikacja wyniku koncowego algorytmu

 for p=1:P
    ocena(p,i) = funkcja(populacja(:,p), gray) ;
 end
    
X = zeros(1,P) ;
for i=1:P
  X(i) = -1 + bi2de( populacja(:,i)', gray) * 3 / (2^22-1) ;
end
    temporary = find( ocena(:,100)== max( ocena(:,100))) ; 
x_opt(proba) = X( temporary(1) ) ; 
y_opt(proba) = max( ocena(:,100) ) ;

end
%% koniec petli glownej %%%%%%%%%%%%%%%%%%%%%%%

x = -1:0.01:2 ; 
y = x.*sin(10*pi*x)+1 ;  
plot( x ,y ) ; 
hold on
plot( x_opt, y_opt, '*') ; 
hold off  
xlabel(' x ' ) ; 
ylabel('f(x)') ;

mean_y_opt = mean( y_opt )
std_y_opt = std(y_opt) 

plot( mean( ocena) ) ;
xlabel(' epoka ' ) ; 
ylabel('srednie przystosowanie') ;
plot(std(ocena) ) ; 
xlabel(' epoka ' ) ; 
ylabel('odchylenie std przystosowania') ; 
plot( max(ocena) ) ;
xlabel(' epoka ' ) ; 
ylabel('przystosowanie najlepszego osobnika') ; 

    
    
    
    
    
