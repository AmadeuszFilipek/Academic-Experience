
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


using namespace std;

double Potential(double ) ;
void DoPrzodu( vector<double> & , double ) ;
void DoTylu( vector<double> & , double ) ;
int Test( vector<double> & , vector<double> & , double ) ;
double EnergiaStudni ( int , double ) ;


int L = 10  ;  /// nm
double DeltaX = 0.01 ; /// nm
double N = 1001 ;

int main() {

DeltaX = 0.01 * 18.8972  ; /// przeskalowanie na jednostki atomowe
vector<double> Fi( N , 0 ) ;
Fi[0] = 0  ;
Fi[1] = pow(10,-5) ;
vector<double> Phi( N , 0 ) ;
Phi[N-1] = 0 ;
Phi[N-2] = pow(10,-5) ;
double EnergiaStanu = -0.5 * 0.03649 ; /// start w jednostkach atomowych
int i = 1 ;

ofstream Plik ("data.txt") ;

while( i != 2 ) {

        if ( Test(Fi , Phi, EnergiaStanu ) ) {
                cout << EnergiaStanu / 0.03649 << endl  ; /// przeskalowanie z jednostek atomowych na eV
                i ++ ;
                for( int k = 0 ; k < N; k ++ )
                Plik << Fi[k] << " " << Phi[k] <<  endl ;
            }
        EnergiaStanu += pow( 10, -6 ) * 0.03649 ; /// przeskalowanie na jednostki atomowe ( w sumie tutaj nie potrzebne )
        if ( EnergiaStanu > 0 )
            break ;
        }
return 0 ;
}

void DoPrzodu( vector<double> & Fi , double Energy){

for(int i = 0 ; i < 450 + 5 ; i ++ )
        Fi[i+2] = 1/(1+DeltaX*DeltaX/12*2*(Energy - Potential(i+2))) * (2*Fi[i+1]*(1-5*DeltaX*DeltaX/12*2*(Energy - Potential(i+1))) - Fi[i]*(1+DeltaX*DeltaX/12*2*(Energy - Potential(i))) ) ;
}
void DoTylu( vector<double> & Fi , double Energy){

for(int i = N - 1 ; i > 450 - 5 ; i -- )
        Fi[i-2] = 1/(1+DeltaX*DeltaX/12*2*(Energy - Potential(i-2))) * (2*Fi[i-1]*(1-5*DeltaX*DeltaX/12*2*(Energy - Potential(i-1))) - Fi[i]*(1+DeltaX*DeltaX/12*2*(Energy - Potential(i))) ) ;
}
double Potential(double i ) {

  return -0.5 * exp( -2 * pow( (i - (N-1)/2 )/(N-1) * L ,2) ) * 0.03649 ; /// jednostki eV przeskalowane na j. at.

}
int Test( vector<double> & Fi, vector<double> & Phi , double Energia) {

    DoPrzodu(Fi, Energia ) ;
    DoTylu(Phi , Energia ) ;

    double Chi ;

 for( int i = 0 ; i < Phi.size() ; i ++ )
   Phi[i] = Phi[i] * fabs( Fi[450] / Phi[450] ) ;


   Chi = 1/Fi[450] * ( Fi[450 - 1] - Phi[450 - 1] ) ;
   if ( fabs(Chi) < pow( 10, -7 ) )
        return 1 ;

    return 0 ;
}
