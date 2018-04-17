
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <fstream>

using namespace std;

int main (int argc , char ** argv ) {
ifstream plik(argv[1]) ;
if( ! plik.good() ){
 cout<< "niepoprawny plik" << endl ;
return 0 ;
}
vector<double> fi(10000) ;
double suma = 0;
int i = 0 ;
while ( plik.good() ){
plik >> fi[i]  ;
suma = suma + fi[i] ;
i ++ ;
}
double L = 21.5 ; /// dla defektu 21.125
ofstream file("norma.txt") ;
for ( int i= 0 ; i < 10000 ; i ++ ) {
    file << fi[i] / suma << ' ' << i * L /(10000-1) * 0.052917721092 << endl ;
}

return 0 ;
}
