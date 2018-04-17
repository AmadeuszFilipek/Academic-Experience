#include <cstdlib>
#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>

#define g 9.81
#define PI 3.14159265359

using namespace std ;

int main () {
    ofstream File("Okres.txt") ;

    double Fi0 = PI/180 ;
    double R = 1 ;
    double Amplituda = Fi0 ;
    double Omega0 = 0 ;
    double Beta = sqrt(g/R) ;
    double N = 1000000 ;
    double DeltaT = 100./N ;
         int flag = 0 ;
            double temp = 0 ;
    vector<double> Fi;
    vector<double> Omega ;
    vector<double> Energia ;
    vector<double> Okres(180) ;
    for(int j = 0 ; j < 180 ; j ++ ){

            Fi.push_back(Fi0*(j+1)) ;
            Omega.push_back(Omega0);
            for (int t = 0 ; t < N ; t ++) {
            Omega.push_back( Omega[t] - Beta*Beta * sin(Fi[t])*DeltaT ) ;
            Fi.push_back(Fi[t] + Omega[t+1]*DeltaT ) ;
            }

            for (int i = 0 ; i < N-1 ; i ++ ) {
                    if( (Fi[i] > 0 && Fi[i+1] < 0) || (Fi[i] < 0 && Fi[i+1] > 0 ) ){
                    flag ++ ;
                    if( !(flag%3 - 1) )
                    temp = i*DeltaT ;
                    if( ! (flag%3) ){
                    Okres[j] = i*DeltaT - temp ;
                    flag = flag%3 ;
                    }
                    }
            }
    Omega.clear();
    Fi.clear();
    File<< j <<' '<< Okres[j] << endl ;

    }

    File.close() ;

    return 0 ;
}

