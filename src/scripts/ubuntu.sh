#!/bin/bash -e

export CXX=`which clang++`
export CC=`which clang`
export APEX_ROOT=$HOME/src/xpress-apex/install

# clean up
rm -rf build

# Configure
cmake -B build \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ARCH_NATIVE=ON \
-DKokkos_ARCH_INTEL_DG1=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DWITH_KokkosKernels=OFF \
-DKokkosKernels_ENABLE_EXAMPLES=OFF \

#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j8
ctest --test-dir build --rerun-failed --output-on-failure
