#include <thread>
#include <future>
#include <vector>
#include <iostream>
#include <unistd.h>
#include "std_thread.hpp"

const size_t nthreads{std::thread::hardware_concurrency()};

void doWork(int scale = 1) {
    constexpr size_t sleep_us{10000};
    usleep(sleep_us * scale);
}

int foo(int tid) {
    static std::mutex mtx;
    {
        std::scoped_lock lock(mtx);
        std::cout << __func__ << " : Thread " << tid << " working!" << std::endl;
    }
    // "do some work"
    doWork(tid);
    return 1;
}

int someThread(int tid)
{
    // "do some work"
    doWork();
    // call child function
    auto t = std::async(std::launch::async, foo, tid+1);
    // stop timer while waiting on worker
    int result = t.get();
    // "do some work"
    doWork();
    return result;
}

int main (int argc, char** argv) {
    UNUSED(argc);
    UNUSED(argv);
    // "do some work"
    doWork();
    // create threads to work asynchronously
    std::vector<std::thread> threads;
    for (size_t i = 0 ; i < nthreads ; i++) {
        threads.push_back(std::thread(someThread,i));
    }
    // join the workers
    for (auto& t : threads) {
        t.join();
    }
    // "do some work"
    doWork();
    return 0;
}

