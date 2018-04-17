#include <cstdlib>
#include <iostream>
#include <cmath>
#include <vector>
#include <fstream>

#define PI 3.14159265359

using namespace std ;

int main() {

double alfa = PI/6 ; /// to jest alfa a kat stozka to 2 alfa
int N = 1000000 ;
double DT = 10./N ;
vector<double> Fi( N ) ;
vector<double> Omega( N ) ;
vector<double> Z( N ) ;
vector <double> V( N ) ;

Fi[0] = PI;
Z[0] = 1 ;
Omega[0] = 0;
V[0] = 0 ;

double Energy ;
ofstream File("Energia") ;
ofstream Plik("Symulacja") ;

for(int i = 1 ; i < N ; i ++){

Fi[i] = Fi[i-1] + Omega[i-1]*DT ;
Z[i] = Z[i-1] + V[i-1] * DT ;
Omega[i] = Omega[i-1] - ( 9.81*pow(cos(alfa),2)/sin(alfa)*sin(Fi[i-1])/Z[i-1] + 2*V[i-1]*Omega[i-1]/Z[i-1] )*DT ;
V[i] = V[i-1] + ( pow(sin(alfa),2)*Z[i-1]*pow(Omega[i-1],2) - 9.81*sin(alfa)*pow(cos(alfa),2)*(1-cos(Fi[i-1])) )*DT ;

Energy = pow( tan(alfa)*Z[i]*Omega[i] ,2 )/2 + pow(V[i]/cos(alfa),2 )/2 + 9.81 * Z[i] * sin(alfa) * (1 - cos(Fi[i])) ;

Plik << i * DT << ' ' << Z[i] << ' ' << Fi[i] << endl ;
File << i * DT <<' '<< Energy << endl ;

if ( Z[i] < 0.00001 )
    break ;
}


return 0 ;
}
