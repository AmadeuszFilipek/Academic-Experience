#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>
#include <complex>
#include <random>
#include <chrono>
#include <complex>
#include <windows.h>

using namespace std;

double Potential( int  ) ;
bool Warunek ( vector<double> & ) ;
void Norma ( vector<double> & ) ;
double Transmisja ( vector<double> & ) ;
double Odbicie ( vector<double> & ) ;

int N = 2001 ;        /// (i-1000)/(N-1)*L
double L = 200 ;     /// x = [-100,100] nm
double deltaT = 0.1 ;
double deltaX = 0.1 * 18.8972 ; /// nm przeskalowane na j. at.
double Xo = -4 ;
double sigma = 1 ;
double k = -0.15 ;
double ENERGY = 0.3 ;

int main ()
{


    vector< complex<double> > Fi(N , (0,0) ) ;
    vector< complex<double> > Last ;
    vector< complex<double> > Second ;
    vector< double > Density(N , 0 ) ;
    ofstream Plik( "data.txt" ) ;

for(double s = 0.01 ; s < 0.1 ; s+=0.01 )
{
 ENERGY = s ;
    for ( int i =1 ; i < N-1  ; i ++ )                                                 /// warunki poczatkowe
    {
        Fi[i].real( exp( -pow( (i-1000.)/(N-1.)*L-Xo , 2 )/pow(sigma,2) ) * cos( - k * (i-1000.)/(N-1.)*L  * 18.8972 ) ) ; /// tutaj domnazam aby k w j.at. bylo mnozone
        Fi[i].imag( exp( -pow( (i-1000.)/(N-1.)*L-Xo , 2 )/pow(sigma,2) ) * sin( - k * (i-1000.)/(N-1.)*L  * 18.8972 ) ) ; /// przez X w j. at.
    }

/// krok pierwszy obliczen
    Last = Fi ;
    for ( int i = 1 ; i < N-1 ; i ++ )
    {
        Fi[i] = Last[i] - complex<double>(0,1) * deltaT * ( -1./2./pow(deltaX,2) *( Last[i+1] - 2.*Last[i] + Last[i-1] ) + Potential( i ) * Last[i] ) ;
    }
    bool FLAG = 1 ;
/// algorytm
    int j = 0 ;
    while ( j <  1000000 ) ///
    {
        Second = Last ;
        Last = Fi ;

        for ( int i = 1 ; i < N -1 ; i ++ )
        {
            Fi[i] = Second[i] - complex<double>(0,1) * 2. * deltaT * ( - 1./2./pow(deltaX,2) * ( Last[i+1] -2.* Last[i] + Last[i-1] ) + Potential( i ) * Last[i] ) ;

        }

        for ( int i = 1 ; i < N -1 ; i ++ )
        {
            Density[i] = Fi[i].real() * Fi[i].real() + Fi[i].imag() * Fi[i].imag() ;

        }
        Norma( Density ) ;

        if( Warunek(Density) == 0 )
            FLAG = 0;
        if ( FLAG == 0 )
        {
            if (Warunek(Density) == 1 )
            {
                cout << Odbicie(Density)  << ' ' << Transmisja(Density)<< endl ;
             //   cout<< j << endl ;
                break ;
            }
        }

        j ++ ;
    }
}
 //   for( int i = 0 ; i < N ; i ++ )
  //      Plik << (i-1000.)/(N-1.)*L << ' ' << Density[i] << endl ;
    Plik.close() ;
    return 0 ;
}

double Potential( int i )
{

    if ( ((i-1000.)/(N-1.)*L) > -2.5 && ((i-1000.)/(N-1.)*L) < 2.5 )
        return ENERGY * 0.03649 ; /// eV przeskalowane na j. at.
    else
        return 0 ;
}
bool Warunek ( vector<double> & density )
{

    double suma = 0 ;

    for ( int i = 917 ; i < 1084 ; i ++ )
    {
        suma += density[i] * deltaX ;
    }

    if ( suma < 0.02 )
        return 1 ;

    return 0;
}
void Norma ( vector<double> & density)
{

    double suma = 0 ;
    for(int i = 0 ; i < density.size() ; i ++ )
    {
        suma += density[i] * deltaX ;
    }
    for(int i = 0 ; i < density.size() ; i ++ )
    {
        density[i] = density[i] / suma ;
    }
    // cout << suma << endl ;
//  cout<< deltaX << endl ;
}
double Transmisja ( vector<double> & density )
{
    double suma = 0 ;
    for( int i = 1084 ; i < N ; i ++ )
        suma += density[i] * deltaX ;
    return suma ;
}
double Odbicie ( vector<double> & density )
{
    double suma = 0 ;
    for( int i = 0 ; i < 918 ; i ++ )
        suma += density[i] * deltaX ;
    return suma ;
}

