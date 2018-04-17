#include <iostream>
#include <cmath>
#include <vector>
#include <fstream>

#define PI 3.14159265359

using namespace std;

double energie(double m, double p_r,double p_phi,double r,double e,double B) ;


int main() {

    ofstream File("trajektoria") ;
    ofstream Enea("energia") ;

    int N = pow(10, 5 ) ;
    double DT = 10./N ;

    vector<double> Fi(N) ;
    vector<double> R(N) ;
    vector<double> Pr(N) ;
    /// warunki poczatkowe
    Fi[0] = 0 ;
    R[0] = sqrt(2) ;
    Pr[0] = 0;
    /// ////////////// reszta wielkosci jest sprowadzona do 1

    for(int i = 1 ; i < N ; i ++ ) {

    Fi[i] = Fi[i-1] + ( 1./pow(R[i-1],2) - 1./2 ) * DT ;
    R[i] = R[i-1] + Pr[i-1] * DT ;
    Pr[i] = Pr[i-1] + ( 1./pow(R[i-1],3) - R[i-1]/4 ) * DT ;

    File << i * DT <<' '<< Fi[i] << ' ' << R[i] << endl ;
    Enea << i * DT << ' ' << energie(1,Pr[i], 1, R[i] , 1 ,1 ) << endl ;

    }

    File.close();
    Enea.close();

    return 0 ;
}

double energie(double m, double p_r,double p_phi,double r,double e,double B){
    return (p_r*p_r + p_phi*p_phi/(r*r))/(2*m) - e*B*p_phi/(2*m) + e*e*B*B*r*r/(8*m);
}
