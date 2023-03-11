#include <omp.h>
#include <stdio.h>
#include "unused.h"

void a(void) {
    printf("in function a\n");
}
void b(void) {
    printf("in function b\n");
}
void c(void) {
    printf("in function c\n");
}

int main (int argc, char** argv) {
    UNUSED(argc);
    UNUSED(argv);
#pragma omp parallel sections
    {
    #pragma omp section
        a();
    #pragma omp section
        b();
    #pragma omp section
        c();
    }
}
