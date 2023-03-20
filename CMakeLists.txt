cmake_minimum_required(VERSION 3.20.1) # Minimum required for CUDA

# set the project name and version
project(Tutorial VERSION 1.0 LANGUAGES C CXX)

option (WITH_Kokkos "Enable Kokkos examples" TRUE)
option (WITH_TargetOffload "Enable OpenMP Target Offload examples" FALSE)
option (WITH_PerfStubs "Enable PerfStubs examples" TRUE)
option (WITH_KokkosKernels "Enable Kokkos Kernels examples" FALSE)
option (WITH_HIP "Enable HIP examples" FALSE)
option (WITH_CUDA "Enable CUDA examples" FALSE)
option (WITH_LEVEL0 "Enable LEVEL0 (OneAPI) examples" FALSE)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
#add_compile_options(-Wall -Wextra -pedantic)
#if(APPLE)
#    set(CMAKE_EXE_LINKER_FLAGS
#        "${CMAKE_EXE_LINKER_FLAGS} -force_flat_namespace -undefined dynamic_lookup")
#    set(CMAKE_SHARED_LINKER_FLAGS
#        "${CMAKE_SHARED_LINKER_FLAGS} -undefined dynamic_lookup")
#else(APPLE)
#      set(CMAKE_SHARED_LINKER_FLAGS
#          "${CMAKE_SHARED_LINKER_FLAGS} -unresolved-symbols")
#endif(APPLE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(MPI) # optional
find_package(OpenMP) # optional
include(cmake/AddGitSubmodule.cmake)

if(NOT DEFINED $APEX_ROOT)
    if(DEFINED ENV{APEX_ROOT})
        message("   env APEX_ROOT is defined as $ENV{APEX_ROOT}")
        set(APEX_ROOT $ENV{APEX_ROOT} CACHE STRING "Path to APEX installation")
    elseif(DEFINED $APEX_PATH)
        message("   APEX_ROOT is defined as ${APEX_PATH}")
        set(APEX_ROOT ${APEX_PATH} CACHE STRING "Path to APEX installation")
    elseif(DEFINED $APEX_DIR)
        message("   APEX_ROOT is defined as ${APEX_DIR}")
        set(APEX_ROOT ${APEX_DIR} CACHE STRING "Path to APEX installation")
    endif()
endif()
find_package(APEX REQUIRED)

#[[
if (NOT APEX_FOUND)
    include(cmake/AddGitSubmodule.cmake)
    # Build Binutils as part of APEX
    set(APEX_WITH_BFD TRUE CACHE BOOL "Include Binutils support for APEX")
    set(APEX_BUILD_BFD TRUE CACHE BOOL "Build Binutils support for APEX")
    # Build Tuning support as part of APEX
    set(APEX_WITH_PLUGINS TRUE CACHE BOOL "Include Plugins support for APEX")
    set(APEX_WITH_ACTIVEHARMONY TRUE CACHE BOOL "Include Active Harmony support for APEX")
    set(APEX_BUILD_ACTIVEHARMONY TRUE CACHE BOOL "Build Active Harmony support for APEX")
    # Include MPI support as part of APEX
    if(MPI_FOUND)
        set(APEX_WITH_MPI ${KokkosTools_ENABLE_MPI} CACHE BOOL "Include MPI support for APEX")
    endif(MPI_FOUND)
    # Include Device-specific support as part of APEX
    if(WITH_CUDA)
        set(APEX_WITH_CUDA TRUE CACHE BOOL "Include CUDA support for APEX")
    endif(WITH_CUDA)
    if(WITH_HIP)
        set(APEX_WITH_HIP TRUE CACHE BOOL "Include HIP support for APEX")
    endif(WITH_HIP)
    if(WITH_LEVEL0)
        set(APEX_WITH_LEVEL0 TRUE CACHE BOOL "Include LEVEL0 support for APEX")
    endif(WITH_LEVEL0)
    # Add openmp support as long as the compiler supports OMPT - definitely not GNU though.
    if(OpenMP_FOUND)
        if (NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
            set(APEX_WITH_OMPT TRUE CACHE BOOL "Include OpenMP support for APEX")
        endif ("${CMAKE_CXX_COMPILER_ID}" NOT STREQUAL "GNU")
    endif(OpenMP_FOUND)
    add_git_submodule(apex)
endif(NOT APEX_FOUND)
]]
enable_testing()

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

add_custom_target(tutorial.tests)
add_custom_command(TARGET tutorial.tests POST_BUILD COMMAND ctest -R test --output-on-failure --timeout 100)

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

if (WITH_HIP)
find_package(ROCTX)
if(ROCTX_FOUND)
    add_subdirectory(src/HIP)
endif()
endif (WITH_HIP)

if (WITH_CUDA)
    find_package(CUDA)
    if(CUDA_FOUND)
        add_subdirectory(src/CUDA)
    endif()
endif()

if (WITH_LEVEL0)
    add_subdirectory(src/OneAPI)
endif()

if(MPI_FOUND)
    message(STATUS "Run: ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} ${MPIEXEC_PREFLAGS} EXECUTABLE ${MPIEXEC_POSTFLAGS} ARGS")
    add_subdirectory(src/C++/MPI)
endif(MPI_FOUND)

function(dump_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            if (NOT MATCHED)
                continue()
            endif()
        endif()
        message(STATUS "${_variableName} = ${${_variableName}}")
    endforeach()
endfunction()

message(STATUS "----------------------------------------------------------------------")
message(STATUS "APEX Variable Report:")
message(STATUS "----------------------------------------------------------------------")
dump_cmake_variables("^APEX")
MESSAGE(STATUS "Build type: " ${CMAKE_BUILD_TYPE})
MESSAGE(STATUS "Libraries: " ${LIBS})
MESSAGE(STATUS "Compiler cxx debug flags:" ${CMAKE_CXX_FLAGS_DEBUG})
MESSAGE(STATUS "Compiler cxx release flags:" ${CMAKE_CXX_FLAGS_RELEASE})
MESSAGE(STATUS "Compiler cxx min size flags:" ${CMAKE_CXX_FLAGS_MINSIZEREL})
MESSAGE(STATUS "Compiler cxx flags:" ${CMAKE_CXX_FLAGS})
MESSAGE(STATUS "Install Prefix:" ${CMAKE_INSTALL_PREFIX})
message(STATUS "----------------------------------------------------------------------")

