#!/bin/bash -e

export CXX=`which hipcc`
export CC=`which amdclang`
export APEX_ROOT=$HOME/src/apex/install_gilgamesh_5.5.3

# clean up
rm -rf build

# Configure
set -x
cmake -B build \
-DWITH_KokkosKernels=OFF \
-DWITH_Kokkos=ON \
-DWITH_HIP=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_HIP=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_VEGA90A=ON \
-DKokkos_ENABLE_TUNING=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=OFF \
-DKokkosKernels_ENABLE_TESTS=ON \
-DROCTX_ROOT=/opt/rocm-5.5.3/roctracer \

set +x
#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j16
ctest --test-dir build
