cmake_minimum_required(VERSION 3.20.1) # Minimum required for CUDA

# set the project name and version
project(Tutorial VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
find_package(APEX REQUIRED)
find_package(MPI) # optional
find_package(OpenMP) # optional

include_directories(${APEX_INCLUDE_DIRS})
set(LIBS ${LIBS} ${APEX_LIBRARIES} pthread)

enable_testing()

include(cmake/AddGitSubmodule.cmake)
add_git_submodule(kokkos)
add_git_submodule(kokkos-kernels)

add_custom_target(tests)
add_custom_command(TARGET tests POST_BUILD COMMAND ctest -R test --output-on-failure --timeout 100)

add_subdirectory(src/C++/std_thread)
add_subdirectory(src/C++/kokkos)
if(MPI_FOUND)
    message(STATUS "Run: ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} ${MPIEXEC_PREFLAGS} EXECUTABLE ${MPIEXEC_POSTFLAGS} ARGS")
    add_subdirectory(src/C++/MPI)
endif(MPI_FOUND)
