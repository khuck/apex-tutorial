#include <iostream>
#include <array>
#include <algorithm>
#include "apex_api.hpp"
#if defined (_OPENMP)
#include "omp.h"
#else
#define omp_get_max_threads() 1
#endif

const size_t nthreads{std::min<size_t>(8,std::thread::hardware_concurrency())};

const size_t DEFAULT_NUM_CELLS{1024*1024};
const size_t DEFAULT_BLOCK_SIZE{DEFAULT_NUM_CELLS/1024};
constexpr size_t DEFAULT_NUM_ITERATIONS{20000};
const size_t DEFAULT_UPDATE_INTERVAL{DEFAULT_NUM_ITERATIONS/100};
constexpr size_t DIVIDE_METHOD{1};
constexpr size_t MULTIPLY_METHOD{2};

long num_cells = DEFAULT_NUM_CELLS;
long block_size = DEFAULT_BLOCK_SIZE;
long active_threads = omp_get_max_threads();
long num_iterations = DEFAULT_NUM_ITERATIONS;
long update_interval = DEFAULT_UPDATE_INTERVAL;
long method = MULTIPLY_METHOD;
const std::string method_names[] = {"divide","multiply"};
apex_event_type my_custom_event = APEX_CUSTOM_EVENT_1;
double accumulated_aggregate;

/**
 * Parse the arguments passed into the program
 */
void parse_arguments(int argc, char ** argv) {
    if (argc > 1 && argc < 7) {
        std::cout << "Usage: " << argv[0] << " -c <num_cells> -b <block_size> -i <iterations>" << std::endl;
        exit(0);
    }
    for (int i = 1 ; i < argc ; i+=2) {
        if (strncmp(argv[i], "-c", 2) == 0) {
            std::cout << "num_cells: " << argv[i+1] << std::endl;
            num_cells = atoi(argv[i+1]);
        } else if (strncmp(argv[i], "-b", 2) == 0) {
            std::cout << "block_size: " << argv[i+1] << std::endl;
            block_size = atoi(argv[i+1]);
        } else if (strncmp(argv[i], "-i", 2) == 0) {
            std::cout << "iterations: " << argv[i+1] << std::endl;
            num_iterations = atoi(argv[i+1]);
        } else {
            std::cerr << "Bad argument: " << argv[i] << std::endl;
            std::cout << "Usage: " << argv[0] << " -c <num_cells> -b <block_size> -i <iterations>" << std::endl;
            exit(0);
        }
    }
    update_interval = num_iterations / 100;
}

/**
 * Initialize the 1D stencil with zeroes or random values.
 */
std::vector<double> * initialize(bool zeroes) {
    std::vector<double> * my_array = new std::vector<double>(num_cells);
    double value = 0.0;
    for ( auto it = my_array->begin(); it != my_array->end(); ++it ) {
        if (zeroes) {
            *it = 0.0;
        } else {
            *it = ((double) rand() / (RAND_MAX));;
        }
        value = value + 1.0;
    }
    return my_array;
}

/**
 * Dump the 1D stencil (useful for debugging)
 */
void dump_array(std::vector<double> * my_array) {
    std::cout << "my_array contains: [";
    for ( auto it = my_array->begin(); it != my_array->end(); ++it ) {
        std::cout << ',' << *it;
    }
    std::cout << ']' << std::endl;
    return;
}

/**
 * Solve one cell of the stencil, using two additions and a division
 */
inline void solve_cell_a(std::vector<double> & in_array, std::vector<double> & out_array, long index) {
    if (__builtin_expect(index == 0,0)) {
        out_array[index] = (in_array[index] +
                            in_array[index+1]) / 2.0;
    } else if (__builtin_expect(index == num_cells - 1,0)) {
        out_array[index] = (in_array[index-1] +
                            in_array[index]) / 2.0;
    } else {
        out_array[index] = (in_array[index-1] +
                            in_array[index] +
                            in_array[index+1]) / 3.0;
    }
}

static const double one_third = 1.0/3.0;
static const double one_half = 0.5;

/**
 * Solve one cell of the stencil, using two additions and a multiplication
 */
inline void solve_cell_b(std::vector<double> & in_array, std::vector<double> & out_array, long index) {
    if (__builtin_expect(index == 0,0)) {
        out_array[index] = (in_array[index] +
                            in_array[index+1]) * one_half;
    } else if (__builtin_expect(index == num_cells - 1,0)) {
        out_array[index] = (in_array[index-1] +
                            in_array[index]) * one_half;
    } else {
        out_array[index] = (in_array[index-1] +
                            in_array[index] +
                            in_array[index+1]) * one_third;
    }
}

/**
 * Solve one block of the 1D stencil, using division
 */
inline void solve_a(std::vector<double> & in_array, std::vector<double> & out_array,
                long start_index, long end_index) {
    apex::scoped_timer((apex_function_address)&solve_a);
    //apex::scoped_timer(__func__);
    long index = 0;
    end_index = std::min(end_index, num_cells);
#pragma omp simd
    for ( index = start_index ; index < end_index ; index++) {
        solve_cell_a(in_array, out_array, index);
    }
}

/**
 * Solve one block of the 1D stencil, using multiplication
 */
inline void solve_b(std::vector<double> & in_array, std::vector<double> & out_array,
                long start_index, long end_index) {
    auto p = apex::start((apex_function_address)&solve_b);
    long index = 0;
    end_index = std::min(end_index, num_cells);
#pragma omp simd
    for ( index = start_index ; index < end_index ; index++) {
        solve_cell_b(in_array, out_array, index);
    }
    apex::stop(p);
}

/**
 * One iteration over the entire 1D stencil, using either
 * multipliation or division.
 */
void solve_iteration(std::vector<double> * in_array, std::vector<double> * out_array) {
    apex::scoped_timer((apex_function_address)&solve_iteration);
    //apex::scoped_timer("solve_iteration");
    if (method == DIVIDE_METHOD) {
#pragma omp parallel num_threads(active_threads)
        {
#pragma omp single
            for (long j = 0; j < num_cells ; j += block_size) {
#pragma omp task
                solve_a(*in_array,*out_array,j,j+block_size);
            }
#pragma omp taskwait
        }
    } else {
#pragma omp parallel num_threads(active_threads)
        {
#pragma omp single
            for (long j = 0; j < num_cells ; j += block_size) {
#pragma omp task
                solve_b(*in_array,*out_array,j,j+block_size);
            }
#pragma omp taskwait
        }
    }
}

/**
 * Report the final tuning parameters
 */
void report_stats(void) {
    apex_profile * p = apex::get_profile((apex_function_address)solve_iteration);
    //apex_profile * p = apex::get_profile("solve_iteration");
    double num_blocks = (double)num_cells / (double)block_size;
    double blocks_per_thread = num_blocks / (double)active_threads;
    std::cout << "number of cells: " << num_cells << std::endl;
    std::cout << "number of iterations: " << num_iterations << std::endl;
    std::cout << "number of active threads: " << active_threads << std::endl;
    std::cout << "block size: " << block_size << std::endl;
    std::cout << "number of blocks: " << num_blocks << std::endl;
    std::cout << "blocks per thread: " << blocks_per_thread << std::endl;
    std::cout << "solver method: " << method_names[method-1] << std::endl;
    std::cout << "total time in solver: " << p->accumulated << " seconds" << std::endl;
}

/**
 * The Main function
 */
int main (int argc, char ** argv) {
    apex::init("openmp test", 0, 1);
    apex::apex_options::throttle_concurrency(true);
    apex::apex_options::use_screen_output_detail(true);
    parse_arguments(argc, argv);

    int num_inputs = 2; // 2 for threads, block size; 3 for threads, block size, method
    long * inputs[3] = {0L,0L,0L};
    /* Set the minimum values */
    long mins[3] = {2,128,DIVIDE_METHOD};
    /* We'll set these later */
    long maxs[3] = {0,0,0};    // we'll set these later
    /* Set the step sizes */
    long steps[3] = {2,128,1};
    /* Active Harmony will update the values in these addresses */
    inputs[0] = &active_threads;
    inputs[1] = &block_size;
    inputs[2] = &method;
    /* Set the true max values */
    maxs[0] = active_threads;
    maxs[1] = num_cells/omp_get_max_threads();
    maxs[2] = MULTIPLY_METHOD;
    /* Report at beginning */
    std::cout <<"Tuning Parameters:" << std::endl;
    std::cout <<"\tmins[0]: " << mins[0] << ", maxs[0]: " << maxs[0] << ", steps[0]: " << steps[0] << std::endl;
    std::cout <<"\tmins[1]: " << mins[1] << ", maxs[1]: " << maxs[1] << ", steps[1]: " << steps[1] << std::endl;
    std::cout <<"\tmins[2]: " << mins[2] << ", maxs[2]: " << maxs[2] << ", steps[2]: " << steps[2] << std::endl;
    /* Register a custom event when we'll update the inputs */
    my_custom_event = apex::register_custom_event("Perform Re-block");
    /* Set up the tuning session */
    apex::setup_throughput_tuning((apex_function_address)solve_iteration,
                    APEX_MINIMIZE_ACCUMULATED, my_custom_event, num_inputs,
                    inputs, mins, maxs, steps);

    std::cout <<"Running 1D stencil test..." << std::endl;

    /* Set up the input vector */
    std::vector<double> * prev = initialize(false);
    /* Set up the vector to hold values after the update */
    std::vector<double> * next = initialize(true);
    /* Set our pointer to point to the input vector */
    std::vector<double> * tmp = prev;
    double prev_accumulated = 0.0;
    /* Record our initial positions */
    apex::sample_value("thread count", active_threads);
    apex::sample_value("block size", block_size);
    apex::sample_value("method", method);
    for (int i = 0 ; i < num_iterations ; i++) {
        /* Solve the stencil */
        solve_iteration(prev, next);
        //dump_array(next);
        /* our output is now the input for the next round,
         * and the input we just consumed is the next output */
        tmp = prev;
        prev = next;
        next = tmp;
        /* If we've reached the update interval... */
        if (i % update_interval == 0 && i > 0) {
            /* Get the 'solve_iteration' measurement */
            apex_profile * p = apex::get_profile((apex_function_address)solve_iteration);
            if (p != nullptr) {
                /* compute how long that last round took */
                double next_accumulated = p->accumulated - prev_accumulated;
                prev_accumulated = p->accumulated;
                std::cout << "Iteration: " << i << " accumulated: " << next_accumulated << std::endl;
            }
            /* Trigger the event - Active Harmony will use the
             * time for that last round to evaluate the settings, and
             * try new values */
            apex::custom_event(my_custom_event, NULL);
            /* What are the new valueS? */
            std::cout << "New thread count: " << active_threads;
            std::cout << ", New block size: " << block_size;
            std::cout << ", New method: " << method_names[method-1] << std::endl;
            apex::sample_value("thread count", active_threads);
            apex::sample_value("block size", block_size);
            apex::sample_value("method", method);
        }
    }
    //dump_array(tmp);
    report_stats();
    delete(prev);
    delete(next);
    std::cout << "done." << std::endl;
    apex::finalize();
}
