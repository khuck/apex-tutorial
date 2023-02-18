#!/bin/bash -e

export CXX=`which hipcc`
export CC=`which amdclang`
export APEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# clean up
rm -rf build

# Configure
cmake -B build \
-DWITH_KokkosKernels=OFF \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_HIP=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_VEGA90A=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=OFF \
-DROCTX_ROOT=/opt/rocm-5.2.0/roctracer


#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j16
ctest --test-dir build
