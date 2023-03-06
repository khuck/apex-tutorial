#!/bin/bash -e

export CXX=`which g++`
export CC=`which gcc`
export APEX_ROOT=$HOME/src/apex/install

# clean up
rm -rf build

# Configure
cmake -B build \
-DKokkos_ENABLE_TUNING=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_CUDA=ON \
-DKokkos_ENABLE_CUDA_LAMBDA=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_X86=ON \
-DKokkos_ARCH_AMPERE80=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=ON \


#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j
ctest --test-dir build