#!/bin/bash -e

export CXX=`which icx`
export CC=`which icx`
export APEX_ROOT=$HOME/src/apex/install
export KOKKOS_ROOT=$HOME/src/kokkos/install

# clean up
rm -rf build

# Configure
set -x
cmake -B build \
-DWITH_Kokkos=OFF \
-DWITH_LEVEL0=ON \
-DWITH_PerfStubs=OFF
set +x

# Build
#cmake --build build -j16
cmake --build build --verbose
ctest --test-dir build --timeout 10
