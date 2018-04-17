#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>
#include <complex>
#include <random>
#include <chrono>

#define PI
#define Bohr 0.0529177249 // 1 bohr = tyle nm
#define Hartee 27.2113845 // 1 hartee = tyle eV
#define Tau 0.02418884326555 // 1 Tau = tyle femtosekund

using namespace std;

double Potential( int  ) ;
double Energia_niezachowana( vector<complex<double> > & , vector<double> & ) ;
double Energia_zachowana( vector<complex<double> > & , vector<double> & ) ;
double Polozenie( vector<complex<double> > & )  ;
void normalizacja( vector<complex<double> > &)  ;
double Energy(vector<complex<double> > & , vector<double>  & )  ;
void Fala (vector<complex<double> > &  , double alfa , vector<double> &  )  ;
double Indukowany(vector<complex<double> > & ,  int ) ;

int N = 201 ;
double L = 1000 ;  // nm wymiar pudla
double deltaX = 5./Bohr ; // nm przeliczone na Bohry
double deltaT = 1/Tau ; // fs przeliczone na Tau
double Xo = 300 ; // nm
double sigma = 50 ; // nm
double k = -0.0001 ;  // jednostki atomowe
double mass = 0.067 ; // j. at.
double odleglosc_d = 10./Bohr ; // nm przeskalowane na j.at.
double epsilon = 13.5 ;

int main () {

    double a = 1 ;
    vector < complex<double> > Fi(N) ;
    vector< complex<double> > Last ;
    vector< complex<double> > Second ;
    vector< double > Indukcja(N) ;
    Fi[0] = 0 ;     // warunki brzegowe
    Fi[N-1] = 0 ;

    double Energia1 = 5 ;
    double Energia2= 10 ;

ofstream Plik("ruch.txt" ) ;
ofstream Plik2("energia.txt") ;
ofstream Plik3("fala.txt") ;
///////////////////////////////////////////////////////metoda czasu zespolonego
for (int i = 1 ; i < (N -1) ; i ++ ) {
        Fi[i].real( exp( -pow( (i-100.)/(N-1.)*L-Xo , 2 )/pow(sigma,2) ) ) ;
        Fi[i].imag( exp( -pow( (i-100.)/(N-1.)*L-Xo , 2 )/pow(sigma,2) ) ) ;
}

while (  fabs( Energia1-Energia2 ) > pow( 10, - 6 )  ) {
 Energia2 = Energia1 ;
 normalizacja( Fi  ) ;
        for( int i = 0 ; i < N ; i ++ )
        Indukcja[i] = Indukowany(Fi , i ) ;
 Energia1 = Energy(Fi , Indukcja ) ;
 Fala(Fi, a , Indukcja ) ;
}

// domnazamy ped exp( ikx) aby indukton ruszyl
for (int i = 1 ; i < (N - 1) ; i ++ ) {
        Fi[i] = Fi[i] * exp( complex<double>(0,1) * k * (i-100.)/(N-1.)*L /Bohr  ) ;
        }

/////////////////////////////////// ///////////////////////////////////krok pierwszy obliczen w czasie
    Last = Fi ;
    for( int i = 0 ; i < N ; i ++ )
    Indukcja[i] = Indukowany(Fi , i ) ;
    for ( int i = 1 ; i < (N-1) ; i ++ )
    {
        Fi[i] = Last[i] - complex<double>(0,1) * deltaT * ( -1./2./mass/pow(deltaX,2) *( Last[i+1] - 2.*Last[i] + Last[i-1] ) + ( Potential( i ) + Indukcja[i] ) * Last[i] ) ;
    }
    normalizacja(Fi ) ;

int t = 0 ;
////////////////////////////////////////////////////////////////////// symulacja w czasie
while ( t < 100000 ) {

    Second = Last ;
    Last = Fi ;
    if( (! t%10 ) ) {
    for( int i = 0 ; i < N ; i ++ ) {
    Indukcja[i] = Indukowany(Fi , i ) ; }
    }
    for ( int i = 1 ; i < ( N -1 ) ; i ++ )
        {
            Fi[i] = Second[i] - complex<double>(0,1) * 2. * deltaT * ( - 1./2./mass/pow(deltaX,2) * ( Last[i+1] -2.* Last[i] + Last[i-1] ) + ( Potential( i ) + Indukcja[i] ) * Last[i] ) ;

        }
    normalizacja(Fi ) ;
    t ++ ;

//if(t == 70000 )
//for( int i = 0 ; i < N ; i ++ )
//Plik3 <<  (i-100.)/(N-1)*L << ' ' << Fi[i].real() * Fi[i].real() + Fi[i].imag() * Fi[i].imag() << endl ;

if ( ! ( t%10 ) ) {
Plik << t <<' '<< Polozenie( Fi ) << endl ;
Plik2<< t << ' ' << Energia_niezachowana( Fi , Indukcja ) << ' ' << Energia_zachowana(Fi , Indukcja ) << endl ;  }

}
///////////////////////////////////////////////////////////////////////////////////////

//for (double i = 0 ; i < N ; i ++ ) {
//Plik << (i-100.)/(N-1)*L << ' '<< Fi[i].real() * Fi[i].real() + Fi[i].imag() * Fi[i].imag() << ' ' << endl ; } /// (i-100.)/(N-1)*L  -to jest x


Plik.close() ;
Plik2.close() ;
Plik3.close() ;
return 0 ;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////// definicje //////////////////////////////////////////////////////////////////////
void normalizacja( vector<complex<double> > & Fi ) {
double suma = 0 ;
for ( int i = 0 ; i < (N-1) ; i ++ ) {
    suma += ( Fi[i].real() * Fi[i].real() + Fi[i].imag() * Fi[i].imag() + Fi[i+1].real() * Fi[i+1].real() + Fi[i+1].imag() * Fi[i+1].imag()  ) * deltaX/2. ;
}
for ( int i = 1 ; i < (N - 1 ) ; i ++ ) {
Fi[i] = Fi[i] / sqrt(suma) ;
}

}

double Energy(vector<complex<double> > & Fi , vector<double>  & indukcja ) {
complex<double> suma = 0 ;

for( int i = 1 ; i < (N - 2 ) ; i ++ ) {

    suma += ( conj( Fi[i] ) * ( -1./2./mass/deltaX/deltaX * ( Fi[i+1] -2.*Fi[i] + Fi[i-1] ) + indukcja[i] * Fi[i] ) +
                conj( Fi[i+1] ) * ( -1./2./mass/deltaX/deltaX * ( Fi[i+2] -2.*Fi[i+1] + Fi[i] ) + indukcja[i+1] * Fi[i+1] ) )
                * deltaX/2. ;
}
return suma.real() ; // wynik w j. at.
}

void Fala (vector<complex<double> > & Fi , double alfa , vector<double> & indukcja  ) {
auto temporary = Fi ;

for (int i = 1 ; i < (N - 1) ; i ++ ) {
    temporary[i] = Fi[i] - alfa * ( -1./2./mass/deltaX/deltaX * ( Fi[i+1] -2.*Fi[i] + Fi[i-1] + indukcja[i] * Fi[i] ) ) ;
}
for( int i = 0 ; i < N ; i ++ ) {
    Fi[i] = temporary[i] ;
}

}

double Potential( int i ) {

double X_zero = 0 ; // nm
double a = 200 ; // nm
double V_zero = 0.00001 ; // j. at.

        return -1. * V_zero * exp( -1. * pow( ( (i-100.)/(N-1)*L - X_zero )/a ,2)  ) ;

}

double Polozenie( vector<complex<double> > & Fi ) {

double suma = 0 ;

for ( int i = 0 ; i < N ; i ++  )
suma += ( Fi[i].real()*Fi[i].real()+Fi[i].imag()*Fi[i].imag() ) * (i-100.)/(N-1)*L/Bohr * deltaX ; // L/bohr w jednostkach atomowych

return  suma * Bohr ; // powrót z j. at.

}

double Energia_niezachowana( vector<complex<double> > & Fi , vector<double> & Indukcja ) {

complex<double> suma = 0 ;

for ( int i = 1 ; i < ( N-2 ) ; i ++  )
suma +=( conj( Fi[i] ) * ( -1./2./mass/deltaX/deltaX * ( Fi[i+1] -2.*Fi[i] + Fi[i-1] ) + ( Potential( i ) + Indukcja[i] ) * Fi[i] ) +
            conj( Fi[i+1] ) * ( -1./2./mass/deltaX/deltaX * ( Fi[i+2] -2.*Fi[i+1] + Fi[i] ) + ( Potential( i +1 ) + Indukcja[i+1] ) * Fi[i+1] ) )
            * deltaX/2. ;

return suma.real() ;

}

double Indukowany(vector<complex<double> > & Fi , int a  ) {

double suma = 0 ;

for ( int i = 0 ; i < (N-1) ; i ++ ) {
    suma += (  ( Fi[i].real()*Fi[i].real()+ Fi[i].imag()*Fi[i].imag() ) /
                sqrt( pow( (a-100.)/(N-1)*L/Bohr - (i-100.)/(N-1)*L/Bohr , 2) + 4 * odleglosc_d*odleglosc_d) +
                 ( Fi[i+1].real()*Fi[i+1].real()+ Fi[i+1].imag()*Fi[i+1].imag() ) /
                sqrt( pow( (a-100.)/(N-1)*L/Bohr - (i+1-100.)/(N-1)*L/Bohr , 2) + 4 * odleglosc_d*odleglosc_d) )
                * deltaX/2. ;

}
return  suma* -1./epsilon  ;
}

double Energia_zachowana( vector<complex<double> > & Fi, vector<double> & ind ) {

double suma = 0 ;

for( int i = 0 ; i < (N-1) ; i ++ ) {

    suma +=( ( Fi[i].real()*Fi[i].real()+ Fi[i].imag()*Fi[i].imag() ) * ind[i] +
                ( Fi[i+1].real()*Fi[i+1].real()+ Fi[i+1].imag()*Fi[i+1].imag() ) * ind[i+1] )
                    * deltaX/2. ;

}

return Energia_niezachowana(Fi , ind ) - 1./2.* suma ;
}

