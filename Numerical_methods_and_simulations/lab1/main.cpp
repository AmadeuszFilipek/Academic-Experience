
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>

#define Eprozni 8.854187817
#define PI 3.14159265
#define Mel 9.10938291
#define Eelektronu 1.602176565
#define Planck 6.62606957
#define RBohra 0.52917721092

using namespace std;

double Potential(double ) ;
void Symulacja( vector<double> & , double ) ;
int Test( vector<double> & , double ) ;
double EnergiaStudni ( int , double ) ;
void normalizacja( vector<double> & ) ;
void teoria (vector<double> & , int ) ;

double  L = 5  ;  /// w jednostkach nm
double DeltaX = 0.01 ; /// w jednostkach nm
int N = L/DeltaX + 1 ;

int main() {

DeltaX = 0.01 * 18.8972  ;
vector<double> Fi( N ) ;
Fi[0] = 0  ;
Fi[1] = pow(10,-6) ;
double EnergiaStanu = 0 ; /// jednostki eV
int i = 1 ;

ofstream Plik ("Fala3.txt") ;

while( i != 4 ) {

    if ( Test(Fi , EnergiaStanu )) {
       // Plik << EnergiaStanu / 0.03649 << ' ' << EnergiaStudni(i , L ) << endl  ; /// energie w eV
    if( i == 3 ) {
    normalizacja( Fi ) ;
     for( int j = 0 ; j < N ; ++ j )
        Plik << j*L/(N-1) << ' ' << Fi[j] << ' ' << sqrt( 2/L )*sin(i * PI  * j / (N-1) )  << endl ;
    }
     i ++ ;
    }
EnergiaStanu += pow(10,-6 ) * 0.03649 ; /// jednostki atomowe
}

return 0 ;
};

double EnergiaStudni ( int n , double a ) {

return Planck*Planck*n*n / ( Eelektronu*Mel*8*pow(a,2)   ) ;

}
void Symulacja( vector<double> & Fi , double Energy){

for(int i = 0 ; i < N - 2   ; i ++ )
        Fi[i+2] = 1/(1+DeltaX*DeltaX/12*2*(Energy - Potential(i+2))) * (2*Fi[i+1]*(1-5*DeltaX*DeltaX/12*2*(Energy - Potential(i+1))) - Fi[i]*(1+DeltaX*DeltaX/12*2*(Energy - Potential(i))) ) ;
}
double Potential(double x ) {

  return 0 ;

} ;
int Test( vector<double> & Fi, double Energia) {

    Symulacja(Fi, Energia ) ;

    if ( fabs(Fi[N-1]) < pow(10,-9) )
    return 1 ;

    return 0 ;

}
void normalizacja( vector<double> & Fi ) {

    double suma = 0 ;
 for ( int i = 0 ; i < Fi.size() ; i ++ )
 suma += Fi[i] * Fi[i]  ;

  for ( int i = 0 ; i < Fi.size() ; i ++ )
  Fi[i] = Fi[i] / sqrt(suma) ;
}
void teoria (vector<double> & Phi , int n ) {

 for ( int j = 0 ; j < Phi.size() ; j ++ )
    Phi[j] = sin( n * PI  * j / (Phi.size()-1) ) ;

}
