#!/bin/bash -e

module load cmake cuda/11.4

export CXX=`which icx`
export CC=`which icx`
export APEX_ROOT=$HOME/src/xpress-apex/install_jupiter

# clean up
rm -rf build

# Configure
set -x
cmake -B build \
-DWITH_KokkosKernels=OFF \
-DWITH_Kokkos=OFF \
-DWITH_LEVEL0=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_SKX=ON \
-DKokkos_ARCH_INTEL_DG1=ON \
-DKokkos_ENABLE_TUNING=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=OFF \
-DKokkosKernels_ENABLE_TESTS=ON \

set +x
#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j16
ctest --test-dir build --timeout 10
