
#include <cstdlib>
#include <iostream>
#include <vector>
#include <cmath>
#include <fstream>

#define g 9.81

using namespace std ;

int main(int argc , char ** argv ) {

ofstream File( argv[1] ) ;
cout << argv[1] ;
vector<double> X ;
X.push_back(0);
vector<double> Teoria ;
Teoria.push_back(0);

double Vo = 1000 ;
double mass = 1 ;

vector<double> V ;
V.push_back(Vo) ;

double Delta = 1./ atoi(argv[2]) ;

double Energia = 0 ;

for( int i = 0 ; i < 100000 ;  i ++ ){

X.push_back(X[i]+ Delta * V[i] ) ;

V.push_back(V[i] - g* Delta  ) ;

Teoria.push_back( -g/2*pow(Delta*(i+1),2) + Vo* Delta*(i+1) + Teoria[0] ) ;

Energia = mass * pow(V[i] ,2 )/2 + mass * g * X[i] ;

File <<Delta*i <<' '<< fabs( X[i] - Teoria[i] )   << endl;

if(X[i] < 0 )
break ;
}

File.close() ;

return 0 ;

}
