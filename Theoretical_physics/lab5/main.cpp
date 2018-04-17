
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

using namespace std ;

int main() {
    ofstream plik("nz.txt") ;

    /// dane wejsciowe
    double dx = 10 ; /// nm
    double dy = 10 ;
    double dz = 10 ;
    double nx= 50+1 ;
    double ny= 50+1 ;
    double nz= 20 ;
    /// polozenia elektrod
    vector<vector<double>> Elektrody(6) ;
    Elektrody[0] = {0,21,0,11} ;  /// nx0 , nx1 , ny0 , ny1
    Elektrody[1] = {30,51,0,11} ;
    Elektrody[2] = {0,11,20,31} ;
    Elektrody[3] = {40,51,20,31} ;
    Elektrody[4] = {0,21,40,51} ;
    Elektrody[5] = {30,51,40,51} ;
    double V0 = - 350 ; /// mV , napiecie podloza
    vector<double> NapiecieElektrody = {450,450,300,300,450,450} ; /// mV , napiecia gornych elektrod

    vector< vector <vector<double>> > potential(nx, vector<vector<double>>(ny, vector<double>(nz,0) ) ) ;   /// x , y , z
    vector< vector <vector<double>> > Backpotential = potential ;
while ( nz < 60 ){
        for( int n = 0 ; n <  nz*500  ; n ++ ) {

            /// warunki brzegowe       /// warunek na dolna elektrode
            for ( int i = 0 ; i < nx ; i ++ ) {

                    for( int j = 0 ; j < ny ; j ++ )
                        potential[i][j][0] = V0 ;

            }
            /// elektrody gorne ////////////////////////////////////////////////////////////////
            for (int i = Elektrody[0][0] ; i < Elektrody[0][1] ; i ++ ){

                    for (int j = Elektrody[0][2] ; j < Elektrody[0][3] ; j ++ )
                    potential[i][j][15] =  NapiecieElektrody[0] ;
            }

            for (int i = Elektrody[1][0] ; i < Elektrody[1][1] ; i ++ ){

                    for (int j = Elektrody[1][2] ; j < Elektrody[1][3] ; j ++ )
                        potential[i][j][15] =  NapiecieElektrody[1] ;
            }

            for (int i = Elektrody[2][0] ; i < Elektrody[2][1] ; i ++ ){

                    for (int j = Elektrody[2][2] ; j < Elektrody[2][3] ; j ++ )
                        potential[i][j][15] =  NapiecieElektrody[2] ;
            }

            for (int i = Elektrody[3][0] ; i < Elektrody[3][1] ; i ++ ){

                    for (int j = Elektrody[3][2] ; j < Elektrody[3][3] ; j ++ )
                        potential[i][j][15] =  NapiecieElektrody[3] ;
            }

            for (int i = Elektrody[4][0] ; i < Elektrody[4][1] ; i ++ ){

                    for (int j = Elektrody[4][2] ; j < Elektrody[4][3] ; j ++ )
                        potential[i][j][15] =  NapiecieElektrody[4] ;
            }

            for (int i = Elektrody[5][0] ; i < Elektrody[5][1] ; i ++ ){

                    for (int j = Elektrody[5][2] ; j < Elektrody[5][3] ; j ++ )
                        potential[i][j][15] =  NapiecieElektrody[5] ;
            }

           for ( int i = 0 ; i < ny ; i ++ ) {
                for( int j = 0 ; j < nz ; j ++ ) {
                    potential[0][i][j] = potential[1][i][j] ;           /// warunek na powierzchnie x-owe
                    potential[nx-1][i][j] = potential[nx-2][i][j] ;
            }
            }
            for ( int i = 0 ; i < nx ; i ++ ) {
                for( int j = 0 ; j < nz ; j ++ ) {
                potential[i][0][j] = potential[i][1][j] ;           /// warunek na powierzchnie y-owe
                potential[i][ny-1][j] = potential[i][ny-2][j] ;
            }
            }
            for ( int i = 0 ; i < nx ; i ++ ) {
                for( int j = 0 ; j < ny ; j ++ )
                    potential[i][j][nz-1] = potential[i][j][nz-2] ;           /// warunek na powierzchnie gorna z-owa

            }
            /// //////////////////////////////////////////////////////////////////////
            Backpotential = potential ;

            for(int i = 1 ; i < (nx-1) ; i ++ ) {

                for(int j = 1 ; j < (ny-1) ; j ++ ) {
                    for(int k = 1 ; k < (nz-1) ; k ++ ) {
                        potential[i][j][k] = 1/(2/dx/dx+2/dy/dy+2/dz/dz)*( ( Backpotential[i+1][j][k]+Backpotential[i-1][j][k] )/dx/dx +
                                                                       ( Backpotential[i][j+1][k]+Backpotential[i][j-1][k] )/dy/dy +
                                                                      ( Backpotential[i][j][k+1]+Backpotential[i][j][k-1] )/dz/dz )  ;
                    }
                }
            }

         ///plik  << potential[25][25][11] << endl ;  /// wypis testowy

    }

    cout << "bump" << endl ;
    plik << nz << ' ' << potential[25][25][10] << endl ;  /// wypis testowy
    potential.clear() ;
    Backpotential.clear() ;
    nz = nz + 4 ;
    potential =vector< vector <vector<double>>>(nx, vector<vector<double>>(ny, vector<double>(nz,0) ) ) ;
    Backpotential = potential ;
}
/*
/// tutaj masz wypisac wynikowy rozklad co cie tam interesuje


    for( int i = 0 ; i < nx ; i ++ ) {
            for(int j = 0 ; j < ny ; j ++ )
            plik << i* dx << ' ' << j * dy << ' ' << potential[i][j][10] << endl ;
            plik<< endl ;
    }
*/
return 0 ;
}



