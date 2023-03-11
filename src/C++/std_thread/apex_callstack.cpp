#include <thread>
#include <future>
#include <vector>
#include <iostream>
#include <unistd.h>
#include "std_thread.hpp"
#define PERFSTUBS_USE_TIMERS
#include "perfstubs_api/timer.h"

const size_t nthreads{std::min<size_t>(8,std::thread::hardware_concurrency())};

void doWork(int scale = 1) {
    PERFSTUBS_SCOPED_TIMER_FUNC();
    constexpr size_t sleep_us{10000};
    usleep(sleep_us * scale);
}

__attribute__((__no_instrument_function__))
inline int foo_body(int tid, const std::string& name) {
    static std::mutex mtx;
    {
        std::unique_lock<std::mutex> lock(mtx);
        std::cout << name << " : Thread " << tid << " working!" << std::endl;
    }
    // "do some work"
    doWork(tid);
    return 1;
}

int foo(int tid) {
    PERFSTUBS_SCOPED_TIMER_FUNC();
    return foo_body(tid, std::string(__func__));
}

int someThread(int tid)
{
    // create a scoped timer
    PERFSTUBS_SCOPED_TIMER_FUNC();
    // "do some work"
    doWork();
    // call child function
    int ret = foo(tid+1);
    // "do some work"
    doWork();
    return ret;
}

int main (int argc, char** argv) {
    UNUSED(argc);
    UNUSED(argv);
    PERFSTUBS_INITIALIZE();
    PERFSTUBS_SCOPED_TIMER_FUNC();
    // "do some work"
    doWork();
    // create threads to work asynchronously
    std::vector<std::thread> threads;
    for (size_t i = 0 ; i < nthreads ; i++) {
        someThread(i);
    }
    // "do some work"
    doWork();
    PERFSTUBS_DUMP_DATA();
    PERFSTUBS_FINALIZE();
    return 0;
}

