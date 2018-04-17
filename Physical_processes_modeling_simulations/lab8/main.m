clc 
clear

F = - 1000 ; % Newtonow
L = 3 ; % dlugosc belki, metry
d = 0.1 ; % wysokosc belki , metry
E = 2e11 ; % Pa modul Younga
g = 1 ; % szerokosc belki

J = g * d^3 /12 ; % moment bezw³adnoœci wzgl osi obojetnej
 h = F * L ^3 / 3 / E / J 


