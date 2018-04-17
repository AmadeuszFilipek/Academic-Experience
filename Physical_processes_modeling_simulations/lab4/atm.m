function main 
clc
clear

S_zero = 1366  ; %% W/m^2
c = 2.7 ; %% W/m^2/K
sigma = 5.67e-8 ; %% W/m^2/K^4  

as = 0.19 ; % 
ta = 0.53 ; %
aa = 0.3 ; %
ta_prim = 0.06 ;
aa_prim = 0.31 ; 
S = S_zero ; 
T0 = [ 300 ; 300 ];                                            % Make a starting guess at the solution
% options=optimset('Display','iter');     	  % Option to display output
[T,fval] = fsolve(@myfun, T0 )  ;

T(1) - 273.15

function F = myfun( T )    %% Ts = T(1) , Ta = T(2) 

F = [  (-ta)*(1-as)*S/4+c*(T(1)-T(2) ) + sigma*T(1)^4*(1-aa_prim)-sigma*T(2)^4 ; ...
     -1*(1-aa-ta+aa*ta)*S/4 - c*(T(1)-T(2) )-sigma*T(1)^4*(1-ta_prim-aa_prim)+2*sigma*T(2)^4 ] ;
end

end