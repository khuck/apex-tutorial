#!/bin/bash -e

source /Users/khuck/spack/share/spack/setup-env.sh
spack load cmake kokkos apex
export CXX=`which clang++`
export CC=`which clang`
#export APEX_ROOT=$HOME/src/apex/install_minimal
export APEX_ROOT=`spack location -i apex`
export Kokkos_ROOT=`spack location -i kokkos`

# clean up
rm -rf build

# Configure
cmake -B build \
-DWITH_TargetOffload=OFF \
-DWITH_Kokkos=ON \
-DWITH_KokkosKernels=OFF \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ENABLE_THREADS=ON \
-DKokkos_ENABLE_OPENMP=OFF \
-DKokkos_ARCH_NATIVE=ON \
-DKokkos_ARCH_INTEL_DG1=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=ON \

#-DKokkos_ROOT=${Kokkos_ROOT} \
#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j8
ctest --test-dir build --rerun-failed --output-on-failure
