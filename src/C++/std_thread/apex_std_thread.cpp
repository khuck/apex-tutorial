#include <thread>
#include <future>
#include <vector>
#include <iostream>
#include <unistd.h>
#include "apex_api.hpp"

const size_t nthreads{std::max<size_t>(8,std::thread::hardware_concurrency())};

void doWork(int scale = 1) {
    auto task = apex::scoped_timer(__func__);
    constexpr size_t sleep_us{10000};
    usleep(sleep_us * scale);
}

int foo_body(int tid, const std::string& name) {
    auto task = apex::scoped_timer(name);
    static std::mutex mtx;
    {
        std::scoped_lock lock(mtx);
        std::cout << name << " : Thread " << tid << " working!" << std::endl;
    }
    // "do some work"
    doWork(tid);
    return 1;
}

int foo(int tid) {
    return foo_body(tid, std::string(__func__));
}

int foo_detach(int tid) {
    return foo_body(tid, std::string(__func__));
}

int someThread(int tid)
{
    // register the new thread with apex
    std::string name{"worker-thread"+std::to_string(tid)};
    apex::register_thread(name);
    // create a scoped timer
    auto task = apex::scoped_timer(__func__);
    // "do some work"
    doWork();
    // call child function
    auto t = std::async(std::launch::async, foo, tid+1);
    // create a "fire and forget" thread
    std::thread(foo_detach, tid+1).detach();
    // stop timer while waiting on worker
    task.yield();
    int result = t.get();
    // the result is unused
    APEX_UNUSED(result);
    // restart timer
    task.start();
    // "do some work"
    doWork();
    // exit the thread
    apex::exit_thread();
    return result;
}

int main (int argc, char** argv) {
    APEX_UNUSED(argc);
    APEX_UNUSED(argv);
    // initialize apex
    apex::init("apex::start unit test", 0, 1);
    // always use screen output
    apex::apex_options::use_screen_output(true);
    // create a task for the main function
    auto task = apex::new_task(__func__);
    // start the task
    apex::start(task);
    // "do some work"
    doWork();
    // create threads to work asynchronously
    std::vector<std::thread> threads;
    for (size_t i = 0 ; i < nthreads ; i++) {
        threads.push_back(std::thread(someThread,i));
    }
    // yield the timer for this task, while we wait on workers
    apex::yield(task);
    // join the workers
    for (auto& t : threads) {
        t.join();
    }
    // restart timer for this task
    apex::start(task);
    // "do some work"
    doWork();
    // stop timer and finalize
    apex::stop(task);
    apex::finalize();
    apex::cleanup();
    return 0;
}

