#!/bin/bash -e

# clean up
rm -rf build

# Configure
cmake -B build \
-DWITH_Kokkos=OFF \
-DCMAKE_CXX_COMPILER=`which clang++` \
-DCMAKE_C_COMPILER=`which clang` \
-DAPEX_ROOT=`spack location -i apex`

# Build
cmake --build build -j16
ctest --test-dir build
