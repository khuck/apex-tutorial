#!/bin/bash -e

module load cuda/11.5.0 cmake
module load papi
module load APEX
export CXX=`which g++`
export CC=`which gcc`
export APEX_EXEC=`which apex_exec`
export APEX_ROOT=$(dirname $(dirname ${APEX_EXEC}))

# clean up
rm -rf build

# Configure
cmake -B build \
-DWITH_Kokkos=OFF \
-DKokkos_ENABLE_TUNING=ON \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_CUDA=ON \
-DKokkos_ENABLE_CUDA_LAMBDA=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_AMPERE80=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=ON \
-DCMAKE_CXX_STANDARD_LIBRARIES="-L/appl/spack/v017/install-tree/gcc-11.2.0/cuda-11.5.0-mg4ztb/lib64/stubs -lnvidia-ml" \
-DCMAKE_C_STANDARD_LIBRARIES="-L/appl/spack/v017/install-tree/gcc-11.2.0/cuda-11.5.0-mg4ztb/lib64/stubs -lnvidia-ml" \

# Build
cmake --build build -j
ctest --test-dir build


