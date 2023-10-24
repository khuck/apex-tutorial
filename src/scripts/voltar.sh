#!/bin/bash -e

export CXX=`which nvc++`
export CC=`which nvc`
export APEX_ROOT=$HOME/src/apex/install_voltar_cuda_11.8

# clean up
rm -rf build

# Configure
cmake -B build \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_CUDA=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_VOLTA70=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \


#-DKokkosKernels_ENABLE_EXAMPLES=OFF \
#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j
ctest --test-dir build
