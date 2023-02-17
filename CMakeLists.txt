cmake_minimum_required(VERSION 3.20.1) # Minimum required for CUDA

# set the project name and version
project(Tutorial VERSION 1.0)

option (WITH_Kokkos "Enable Kokkos examples" TRUE)
option (WITH_KokkosKernels "Enable Kokkos Kernels examples" TRUE)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
add_compile_options(-Wall -Wextra -pedantic)
if(APPLE)
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} -force_flat_namespace -undefined dynamic_lookup")
    set(CMAKE_SHARED_LINKER_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -undefined dynamic_lookup")

endif(APPLE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
find_package(APEX REQUIRED)
find_package(MPI) # optional
find_package(OpenMP) # optional

include_directories(${APEX_INCLUDE_DIRS})
set(LIBS ${LIBS} ${APEX_LIBRARIES} pthread)

enable_testing()

if (WITH_Kokkos)
    include(cmake/AddGitSubmodule.cmake)
    add_git_submodule(kokkos)
    if (WITH_KokkosKernels)
        add_git_submodule(kokkos-kernels)
    endif (WITH_KokkosKernels)
endif (WITH_Kokkos)

add_custom_target(tests)
add_custom_command(TARGET tests POST_BUILD COMMAND ctest -R test --output-on-failure --timeout 100)

add_subdirectory(src/C++/std_thread)
if (WITH_Kokkos)
    add_subdirectory(src/C++/kokkos)
endif (WITH_Kokkos)
if(MPI_FOUND)
    message(STATUS "Run: ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} ${MPIEXEC_PREFLAGS} EXECUTABLE ${MPIEXEC_POSTFLAGS} ARGS")
    add_subdirectory(src/C++/MPI)
endif(MPI_FOUND)

