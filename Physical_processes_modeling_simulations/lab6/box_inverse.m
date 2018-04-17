clc
clear
global a;
global b;
b=importdata('opady.prn');
a=importdata('dunaj.prn');
bval=[36,0.5];
[val RMSE] = fminunc(@box_dunaj,bval);
tt = val(1)
Pe = val(2)
