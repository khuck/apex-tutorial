#include <omp.h>
#include <stdio.h>

int main (void) {
	int a, i;
#pragma omp parallel shared(a) private(i)
	{
#pragma omp master
  		a = 0;
  		// To avoid race conditions, add a barrier here.
#pragma omp for reduction(+:a)
  		for (i = 0; i < 10; i++) { a += i; }
#pragma omp master
  		printf ("Sum is %d\n", a);
	}
}
