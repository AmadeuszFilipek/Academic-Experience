#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

#stale

R = 1        #odleglosc srodka masy od osi wahadla
g = 9.81     #stala przyspieszenia grawitacyjnego 
m = 1        #masa ciala drgajacego
I = 1.       #moment bezwladnosci ciala wzgledem osi wahadla
A = 0.       #stala sily oporu ruchu


bins = 100000 # liczba iteracji

T = np.linspace(0,10,bins) #czas
theta = np.zeros(bins)     #kat
omega = np.zeros(bins)     #predkosc katowa
theta[0] = np.pi/180       #warunki poczatkowe
omega[0] = 0.
TeoriaFi = np.zeros(bins)

# "obsluga" przypadku niedeterministycznego 
if theta[0] == np.pi :
	if omega[0]== 0 :
		omega[0] = np.random.random_sample()-0.5
		omega[0] = omega[0]/10

# przebieg symulacji

for i in range(bins-1) :
	
	omega[i+1]= omega[i]+(T[i+1]-T[i])*( -1*(A*R*R*R/I)*omega[i]*np.abs(omega[i]) - (m*g*R/I) * np.sin(theta[i]) )

	theta[i+1]= theta[i] + omega[i]*( T[i+1]-T[i] )

#######################################################################
# rysowanie wykresu

plt.subplot(2, 1, 1)
plt.plot(T,theta,'g-')
plt.title('Theta(t) [Rad]' )
plt.ylabel('Theta [Rad]' )

plt.subplot(2,1,2)
plt.plot(T,omega,'m-')
plt.title('omega(t) [Rad/s]')
plt.ylabel('Omega [Rad/s]')
plt.xlabel('Time [s]')

plt.savefig('wahadlo.png',format='png')



