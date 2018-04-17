#include <cstdlib>
#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>

#define g 9.81
#define PI 3.14159265359

using namespace std ;

int main () {
    ofstream File("dane5.txt") ;
    double N = 50;
    double DeltaT = 10./N ;

    double Fi0 = 0.5*PI/180 ;
    double R = 1 ;
    double Amplituda = Fi0 ;
    double Omega0 = 0 ;
    double Beta = sqrt(g/R) ;


    vector<double> Fi;
    vector<double> Omega ;
    vector<double> Teoria;
    vector<double> Energia ;

    Fi.push_back(Fi0) ;
    Omega.push_back(Omega0);
    /// Energia.push_back(1/2.*pow(R*Omega[0],2) - g* R * cos(Fi[0]) ) ;
    Teoria.push_back( Amplituda* cos(Beta*( 0 )*DeltaT )  ) ;

    for (int t = 0 ; t < N ; t ++) {
        Omega.push_back( Omega[t] - Beta*Beta * sin(Fi[t])*DeltaT ) ;
        Fi.push_back(Fi[t] + Omega[t+1]*DeltaT ) ;
        Teoria.push_back( Amplituda* cos(Beta*(t+1)*DeltaT ) ) ;
        /// Energia.push_back( 1/2.*pow(R*Omega[t+1],2) - g* R * cos(Fi[t+1]) ) ;
    }

for(int i = 0 ; i < N ; i ++ )
File<< i*DeltaT <<' ' << fabs(Teoria[i] - Fi[i]) << endl ;
    File.close() ;

    return 0 ;
}
