
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>

using namespace std;

double Potential(double , double  ) ;
void Symulacja( vector<double> & , double , double ) ;
int RownyPodzial( vector<double> & , double , double, double ,double &) ;
const double N = 10000 ;
const double DeltaX = 21.125 / (N-1) ;

int main() {

double h = (N-1)/21.125;
ofstream plik("EnergiaDefekt.txt") ;
ofstream file("potential") ;

    for(double i =0 ; i < N ; i ++ )
    file << i  * DeltaX <<' '<<Potential(i,h) << endl ;
    file.close();

vector<double> Fi(N) ;
Fi[0] = 0 ;
Fi[1] = DeltaX ;

double EnergyA = 0 ; /// eV
double EnergyB = 0.1 ; /// eV
double EnergiaStanu = 0 ;
int i = 0 ;
while( i != 50 ) {

    if( ! RownyPodzial(Fi,EnergyA,EnergyB,h, EnergiaStanu) ) {
    i++ ;
   plik <<i<<' '<< EnergiaStanu << endl ; /// eV
    cout << EnergiaStanu << endl ;
    }
EnergyA= EnergyB ;
EnergyB += 0.1 ;
}
/*
ofstream dane("Fi.txt") ;
for ( int i=0 ; i < N ; i ++ )
dane << Fi[i] << endl ;
dane.close() ;
*/
return 0 ;
};

void Symulacja( vector<double> & Fi , double Energy , double h ){

   for(int i = 0 ; i < N - 2  ; i ++ ) {
        Fi[i+2] = 1/(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+2,h))) * (2*Fi[i+1]*(1-5*DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+1,h))) - Fi[i]*(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i,h))) ) ;  /// Energy = Energy * 0.07357 ;
        }

}

double Potential(double x , double h ) {

double UpPotential = 300 ;
UpPotential = UpPotential * 0.07357 ;

if ( x/h > 4  ) /// && x/h < 12
 x = x + 0.375*h  ;

for(int  i = 1 ; i < 11 ; i ++ ) {

    if ( (2 * i - 0.5 <= x/h) && (x/h <= 2.0 * i)  )
    //   if( i == 5 )
         //   return UpPotential * 0.75 ; else
             return UpPotential ;

}

  return 0 ;

}

int RownyPodzial( vector<double> & Fi, double A , double B , double h ,double & Energia ) {

    Symulacja(Fi, A , h ) ;
    double a = Fi[ N -1]  ;
    Symulacja(Fi, B , h ) ;
    double b = Fi[ N -1] ;
    if ( a * b > 0 )
    return 1;   /// jak zwraca 1 to znaczy ze na obu koncach jest dodatnia ( ta metoda nic nie znajdzie )

   double x = (A + B)/2.  ;
   int flag = 0 ;

   Symulacja(Fi, x , h ) ;

    if ( fabs( Fi[ N -1 ] ) < 0.00001 ) {
          Energia = x ;  /// eV
          return 0 ;   /// znalazl to czego szukal
        }
   else {
        if ( ! RownyPodzial(Fi, A, x , h ,Energia) )
        return 0 ;
        if ( ! RownyPodzial(Fi, x,  B , h , Energia) )
        return 0 ;
   }
   }
