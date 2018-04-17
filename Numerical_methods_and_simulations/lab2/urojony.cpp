#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>
#include <complex>
#include <random>
#include <chrono>

#define Eprozni 8.854187817
#define PI 3.14159265
#define Mel 9.10938291
#define Eelektronu 1.602176565
#define Planck 6.62606957
#define RBohra 0.52917721092

using namespace std;
void normalizacja( vector<double > &, double)  ;
double Ham(vector<double> & Fi , int i , double deltaX)  ;
double Energy(vector<double> & Fi , double  )  ;
void Fala (vector<double> & Fi , double alfa ,double deltaX)  ;

int N = 1001 ;
double L = 10 ;
double deltaX = 0.01 ;

int main () {

    double a = 0.00001 ;
    vector < double > Fi(N) ;
    Fi[0] = 0 ;     /// warunki brzegowe
    Fi[N-1] = 0 ;

    mt19937 seed(time(NULL)) ;
    normal_distribution<double> gauss(0,1) ;
    double Energia1 = 5 ;
    double Energia2= 10 ;

ofstream Plik("fala2.txt" ) ;

for (int i = 1 ; i < N -1 ; i ++ ) {
       Fi[i] = (i-500.)/(N-1)*L  ;
}

while (  fabs( Energia1-Energia2 ) > pow(10,-7 )  ) {
 Energia2 = Energia1 ;
 normalizacja( Fi , deltaX ) ;
 Energia1 = Energy(Fi, deltaX ) ;
 Fala(Fi, a, deltaX ) ;

}
cout << Energia1 << endl ;
for (double i = 0 ; i < N ; i ++ ) {
    Plik << (i-500)/(N-1)*L << ' '<<Fi[i] << ' ' << exp(   - (i-500)/(N-1)*L * (i-500)/(N-1)*L /2.     ) << endl ; /// (i-500)/(N-1)*L  -to jest x
}

return 0 ;
}

void normalizacja( vector<double > & Fi , double deltaX ) {
double suma = 0 ;
for ( int i = 0 ; i < Fi.size() ; i ++ ) {
    suma +=  Fi[i]*Fi[i]*deltaX ;
}
for ( int i = 0 ; i < Fi.size() ; i ++ ) {
Fi[i] = Fi[i] / sqrt(suma) ;
}

}

double Ham(vector<double> & Fi , int i , double deltaX) {

return -1/2./deltaX/deltaX * ( Fi[i+1] -2*Fi[i] + Fi[i-1] ) + 1/2. * (i-500)/(N-1)*L * (i-500)/(N-1)*L * Fi[i] ; /// (i-500)/(N-1)*L to jest x

}

double Energy(vector<double> & Fi , double deltaX ) {
double suma = 0 ;

for( int i = 1 ; i < Fi.size() - 1 ; i ++ ) {

    suma += Fi[i] * Ham(Fi, i , deltaX) * deltaX ;
}
return suma ;
}

void Fala (vector<double> & Fi , double alfa ,double deltaX) {
auto temporary = Fi ;

for (int i = 1 ; i < Fi.size() - 1  ; i ++ ) {
    temporary[i] = Fi[i] - alfa * Ham(Fi, i , deltaX ) ;
}
for( int i = 0 ; i < Fi.size() ; i ++ ) {
    Fi[i] = temporary[i] ;
}

}
