#include <thread>
#include <future>
#include <vector>
#include <iostream>
#include <unistd.h>

constexpr size_t nthreads{3};

void doWork(int scale = 1) {
    constexpr size_t sleep_us{100000};
    usleep(sleep_us * scale);
}

int foo(int tid) {
    // "do some work"
    std::cout << "Thread " << tid << " working!" << std::endl;
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

