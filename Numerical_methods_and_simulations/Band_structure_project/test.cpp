
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

double Potential(double , double  ) ;
void Symulacja( vector<double> & , double , double ) ;
int RownyPodzial( vector<double> & , double , double, double ,double & ) ;
double EnergiaStudni ( int , double ) ;

double DeltaX = 21.5 / (10000-1) ;
double N = 10000 ;

int main() {

double h = (N-1)/21.5 ;
vector<double> Fi(10000) ;
Fi[0] = 0  ;
Fi[1] = DeltaX ;

double EnergyA = 0 ; /// eV
double EnergyB = 0.1 ; /// eV
double EnergiaStanu = 0;
int i = 0 ;
while( i != 50 ) {

                if( ! RownyPodzial(Fi,EnergyA,EnergyB,h , EnergiaStanu ) ) {
                    i++ ;
                    cout<< " Energia znaleziona : " << EnergiaStanu << endl ;
                    cout<< " Energia teoretyczna : " << EnergiaStudni(i, 21.5 ) << endl ;
                   // cout<< (EnergiaStudni(i, 21.5 ) - EnergiaStanu)*100/EnergiaStudni(i, 21.5 ) << endl ;

                }
                EnergyA = EnergyB ;
                EnergyB += 0.1 ;

}

return 0 ;
};

double EnergiaStudni ( int n , double a ) {

double RBohra = 0.52917721092 ;
return Planck*Planck*n*n/( Eelektronu*8*Mel*pow(a*RBohra,2)   ) * pow(10,2) ;

}
void Symulacja( vector<double> & Fi , double Energy , double h ){

for(int i = 0 ; i < N - 2  ; i ++ )
        Fi[i+2] = 1/(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+2,h))) * (2*Fi[i+1]*(1-5*DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i+1,h))) - Fi[i]*(1+DeltaX*DeltaX/12*(Energy*0.07357 - Potential(i,h))) ) ;
}

double Potential(double x , double h ) {

double UpPotential = 0  ;
UpPotential = UpPotential * 0.07357 ;

int flag = 0 ;
for(double  i = 1 ; i < 11 ; i ++ ) {
    if ( (2 * i - 0.5 <= x/h) && (x/h <= 2.0 * i)  )
     flag = 1 ;

}
if ( flag == 1 )
  return UpPotential;

  return 0 ;

} ;
int RownyPodzial( vector<double> & Fi, double A , double B , double h  , double & Energia) {

    Symulacja(Fi, A , h ) ;
    double a = Fi[ N -1 ]  ;
    Symulacja(Fi, B , h ) ;
    double b = Fi[ N -1 ] ;
    if ( a * b > 0 )
    return 1;   /// jak zwraca 1 to znaczy ze na obu koncach jest dodatnia ( ta metoda nic nie znajdzie )

   double x = (A + B)/2.  ;
   int flag = 0 ;

   Symulacja(Fi, x , h ) ;

    if ( fabs( Fi[ N -1 ] ) < 0.00001 ) {
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
