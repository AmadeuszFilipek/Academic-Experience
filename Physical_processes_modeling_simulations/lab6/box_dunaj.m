function RMSE=box_dunaj(inp)
global a;
global b;
tt=inp(1);
Pe=inp(2);

%ustalenie parametrow symulacji
%C0=11500;                     % stezenie poczatkowe
lambda=4.696e-3;              % stala rozpadu trytu
%inicjacja zmiennych
t_max=a(size(a,1),1);
dt=a(2,1)-a(1,1);
it_max=round(t_max/dt);
c_in=b(:,2);
c_out = zeros(size(c_in,1),1);
NN = 3;                % NN zmienna definiujaca rodzaj modelu
                       % 1 - tlokowy 2 - exponencjalny 3 - dyspersyjny
t_pocz=162;                       
for i= t_pocz:it_max 
   c_out(i) = conv_integral(c_in,i,dt,tt,lambda,Pe,NN);
end;    
t=a(1,1):dt:t_max;
%subplot(2,1,1);
%RMSE=sqrt(sum(((a(t_pocz:end,2)-c_out(t_pocz:end))./a(t_pocz:end,2)).^2));
RMSE=sqrt(sum((a(t_pocz:end,2)-c_out(t_pocz:end)).^2));
plot(a(:,1),a(:,2),'r*',t,c_out,'b-');
xlabel('time (months)');
ylabel('tritium (TU)');
text(400,500,['RMSE ' num2str(RMSE,'%4.3f')]);
text(400,450,['czas przebywania ' num2str(tt,'%4.3f')]);
text(400,400,['liczba Pecleta ' num2str(Pe,'%4.3f')]);

pause(0.01)
[RMSE tt Pe]

