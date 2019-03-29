#include<stdio.h>
#include<stdlib.h>
#include<omp.h>


double f( double x){
    return 1.0/(1.0+x*x);
}

int main(){
    size_t N=1000000000;
    double h=1.0/(N);
    double pi=0.0;
    int i;

    double tstart=omp_get_wtime();
    for( i= 0 ; i <= N-1; i++)
    {
        pi+=f((i*h)+h/2);    
    }
    pi=pi*4*h;
    double duration=omp_get_wtime()-tstart;

    printf("%lf in %lf sec\n", pi,duration);

    return 0;
}