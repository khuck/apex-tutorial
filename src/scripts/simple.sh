#!/bin/bash -e

# clean up
rm -rf build

# Configure
cmake -B build \
-DWITH_Kokkos=OFF \

#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j16
ctest --test-dir build
