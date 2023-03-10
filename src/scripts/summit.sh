#!/bin/bash -e

export CXX=`which g++`
export CC=`which gcc`
export APEX_ROOT=$HOME/src/apex/summit/install

builddir=summit/build
# clean up
rm -rf ${builddir}

# Configure
cmake -B ${builddir} \
-DCMAKE_BUILD_TYPE=Debug \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_CUDA=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_POWER9=ON \
-DKokkos_ARCH_VOLTA70=ON \
-DKokkos_ENABLE_CUDA_LAMBDA=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=ON \


#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build ${builddir} -j
ctest --test-dir ${builddir}
