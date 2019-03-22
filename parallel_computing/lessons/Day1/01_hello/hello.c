#include <stdlib.h>
#include <stdio.h>

int main(int argc, char ** argv) {
    int tid = 1;
    int nthreads = 1;

    printf("Hello from %d out of %d!\n", tid, nthreads);
    return 0;
}
