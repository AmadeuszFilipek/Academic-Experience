
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>

using namespace std;

double Potential(double , double  ) ;
void Symulacja( vector<double> & , double , double ) ;
int RownyPodzial( vector<double> & , double , double, double , double & ) ;
double EnergiaStudni ( int , double ) ;

double DeltaX = 21.5 / (10000-1) ;
double N = 10000 ;

int main() {

double h = (N -1)/ 21.5 ;
ofstream plik("EnergiaNapiecie.txt") ;

vector<double> Fi(N) ;
Fi[0] = 0  ;
Fi[1] = DeltaX ;

ofstream file("potential") ;
for(double i = 0 ; i < N ; i ++ )
file << Potential(i,h) << endl ;
file.close();

double EnergyA = 0 ; /// eV
double EnergyB = 0.1 ; /// eV
double EnergiaStanu = 0 ;
int i = 0 ;

while( i != 50 ) {

     if( ! RownyPodzial(Fi,EnergyA,EnergyB,h, EnergiaStanu ) ) {
                    i++ ;
                    plik<<i<<' '<< EnergiaStanu << endl ;
                    cout << EnergiaStanu << endl ;
                }
    EnergyA = EnergyB ;
    EnergyB += 0.1 ;

}
/*
ofstream dane("Fi.txt") ;
for ( int i=0 ; i < N ; i ++ )
dane << Fi[i] << endl ;
dane.close() ;
*/

return 0 ;
}

void Symulacja( vector<double> & Fi , double Energy , double h ){

   for(int i = 0 ; i < N - 2  ; i ++ )
        Fi[i+2] = 1/(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+2,h))) * (2*Fi[i+1]*(1-5*DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+1,h))) - Fi[i]*(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i,h))) ) ; /// Energy = Energy * 0.07357 ;

}
double Potential(double x , double h ) {

double UpPotential = 300;

for(double  i = 1 ; i < 11 ; i ++ ) {
    if ( (2 * i - 0.5 <= x/h) && (x/h <= 2.0 * i)  )
      return (UpPotential + 40/21.5*x/h - 20 )  * 0.07357;

}
  return ( 40/21.5*x/h - 20 ) *  0.07357 ;
} ;
int RownyPodzial( vector<double> & Fi, double A , double B , double h  , double & Energia) {

    Symulacja(Fi, A , h ) ;
    double a = Fi[ N -1 ]  ;
    Symulacja(Fi, B , h ) ;
    double b = Fi[ N -1 ] ;
    if ( a * b > 0 )
    return 1;   /// jak zwraca 1 to znaczy ze na obu koncach jest dodatnia ( ta metoda nic nie znajdzie )

   double x = (A + B)/2.  ;


   Symulacja(Fi, x , h ) ;

    if ( fabs( Fi[ N-1 ] ) < 0.01 ) {
       Energia = x ;
          return 0 ;   /// znalazl to czego szukal
        }
   else {
        if ( ! RownyPodzial(Fi, A, x , h , Energia ) )
        return 0 ;
        if ( ! RownyPodzial(Fi, x,  B , h, Energia ) )
        return 0 ;
   }

}
