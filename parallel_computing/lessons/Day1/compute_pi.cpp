#include <stdlib.h>
#include <stdio.h>
#include <math.h> // for M_PI

int main(int argc, char ** argv) {
    const int N = 100000000;
    double s = 0.0;
    double x;
    double w = 1.0 / N;
    int nthreads = 1;

    for(int i = 0; i < N; ++i) {
        x = w * (i + 0.5);
        s = s + 1.0 / (1.0 + x*x);
    }

    s = 4.0 * w * s;
    printf("M_PI:       %0.17lf\n", M_PI);
    printf("%2d threads: %0.17lf\n", nthreads, s);

    return 0;
}
