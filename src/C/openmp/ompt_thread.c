#include <unistd.h>
#include <stdio.h>
#include <omp.h>
#include "unused.h"

int main (int argc, char *argv[]) {
    UNUSED(argc);
    UNUSED(argv);
#pragma omp parallel
    {
        printf("Hello from thread %d of %d\n",
            omp_get_thread_num(),
            omp_get_num_threads());
        fflush(stdout);
    }
    return 0;
}

