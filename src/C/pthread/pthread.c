#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define UNUSED(expr) do { (void)(expr); } while (0)
#define NTHREADS 4
#define SLEEP_US 10000

void doWork(long int scale) {
    usleep(SLEEP_US * (scale + 1));
}

__attribute__ ((noinline))
void * foo(void* tmp) {
    long int tid = (long int)(tmp);
    printf("%s : Thread %ld working!\n", __func__, tid);
    /* "do some work" */
    doWork(tid);
    pthread_exit(NULL);
}

void * someThread(void* tmp)
{
    long int tid = (long int)(tmp);
    printf("%s : Thread %ld working!\n", __func__, tid);
    /* "do some work" */
    doWork(tid);
    /* call child function, allow it to run free */
    pthread_t threads[NTHREADS];
    for (long int i = 0 ; i < NTHREADS ; i++) {
	pthread_create(&(threads[i]), NULL, &foo, tmp);
	pthread_detach(threads[i]);
    }
    /* "do some work" */
    doWork(tid);
    pthread_exit(NULL);
}

int main (int argc, char** argv) {
    UNUSED(argc);
    UNUSED(argv);
    /* "do some work" */
    doWork(0);
    /* create threads to work asynchronously */
    pthread_t threads[NTHREADS];
    for (long int i = 0 ; i < NTHREADS ; i++) {
	pthread_create(&(threads[i]), NULL, &someThread, (void*)i);
    }
    /* "do some work" */
    doWork(0);
    // join the workers
    for (long int i = 0 ; i < NTHREADS ; i++) {
        pthread_join(threads[i], NULL);
    }
    /* "do some work" */
    doWork(0);
    return 0;
}

