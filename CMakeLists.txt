cmake_minimum_required(VERSION 3.20.1) # Minimum required for CUDA

# set the project name and version
project(Tutorial VERSION 1.0)

option (WITH_Kokkos "Enable Kokkos examples" TRUE)
option (WITH_TargetOffload "Enable OpenMP Target Offload examples" FALSE)
option (WITH_PerfStubs "Enable PerfStubs examples" TRUE)
option (WITH_KokkosKernels "Enable Kokkos Kernels examples" FALSE)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
add_compile_options(-Wall -Wextra -pedantic)
if(APPLE)
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} -force_flat_namespace -undefined dynamic_lookup")
    set(CMAKE_SHARED_LINKER_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -undefined dynamic_lookup")
else(APPLE)
      set(CMAKE_SHARED_LINKER_FLAGS
          "${CMAKE_SHARED_LINKER_FLAGS} -unresolved-symbols")
endif(APPLE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
find_package(APEX REQUIRED)
find_package(MPI) # optional
find_package(OpenMP) # optional

include_directories(${APEX_INCLUDE_DIRS})
set(LIBS ${LIBS} ${APEX_LIBRARIES} pthread)

enable_testing()

include(cmake/AddGitSubmodule.cmake)
if (WITH_PerfStubs)
    add_git_submodule(perfstubs)
endif (WITH_PerfStubs)
if (WITH_Kokkos)
    add_git_submodule(kokkos)
    if (WITH_KokkosKernels)
        add_git_submodule(kokkos-kernels)
    endif (WITH_KokkosKernels)
endif (WITH_Kokkos)

include(GitExternal)
git_external(rapidjson
    https://github.com/miloyip/rapidjson.git
    master
    VERBOSE)

set(RAPIDJSON_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/rapidjson/include)

if(RAPIDJSON_INCLUDE_DIR)
    message(INFO " Found rapidjson at ${RAPIDJSON_INCLUDE_DIR}")
    include_directories(${RAPIDJSON_INCLUDE_DIR})
else()
    message(FATAL_ERROR " rapidjson not found. This should have been checked out automatically. "
        "Try manually check out https://github.com/miloyip/rapidjson.git to ${PROJECT_SOURCE_DIR}")
endif()

add_custom_target(tests)
add_custom_command(TARGET tests POST_BUILD COMMAND ctest -R test --output-on-failure --timeout 100)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
IF("${isSystemDir}" STREQUAL "-1")
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
ENDIF("${isSystemDir}" STREQUAL "-1")

add_subdirectory(src/C/pthread)
add_subdirectory(src/C++/std_thread)
add_subdirectory(src/C++/tuning)
if(OpenMP_FOUND)
    add_subdirectory(src/C++/openmp)
    add_subdirectory(src/C/openmp)
endif()

if (WITH_Kokkos)
    add_subdirectory(src/C++/kokkos)
    add_subdirectory(src/C++/kokkos-lulesh-2.0)
endif (WITH_Kokkos)

find_package(ROCTX)
if(ROCTX_FOUND)
    add_subdirectory(src/HIP)
endif()

if(MPI_FOUND)
    message(STATUS "Run: ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} ${MPIEXEC_PREFLAGS} EXECUTABLE ${MPIEXEC_POSTFLAGS} ARGS")
    add_subdirectory(src/C++/MPI)
endif(MPI_FOUND)

