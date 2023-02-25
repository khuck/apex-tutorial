#!/bin/bash -e

export CXX=`which hipcc`
export CC=`which amdclang`
export APEX_ROOT=$HOME/install/apex

# clean up
rm -rf build

export PE_PKGCONFIG_PRODUCTS=PE_MPICH
export PE_PKGCONFIG_LIBS=mpich
cc --cray-print-opts=all

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
-DROCTX_ROOT=/opt/rocm-5.0.2/roctracer

# Build
cmake --build build -j16
ctest --test-dir build
