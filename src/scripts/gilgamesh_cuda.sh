#!/bin/bash -e

export CXX=`which g++`
export CC=`which gcc`
export APEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_nvhpc22.9

# clean up
rm -rf build

# Configure
set -x
cmake -B build \
-DWITH_KokkosKernels=OFF \
-DWITH_Kokkos=ON \
-DWITH_CUDA=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_CUDA=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_AMPERE80=ON \
-DKokkos_ENABLE_TUNING=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=OFF \
-DKokkosKernels_ENABLE_TESTS=ON \
-DCUDAToolkit_ROOT=${CUDA} \

set +x
#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j16
ctest --test-dir build --timeout 10
