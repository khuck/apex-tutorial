#!/bin/bash -e

export CXX=`which hipcc`
export CC=`which amdclang`
export APEX_ROOT=$HOME/install/apex_lumi_nompi

# clean up
rm -rf build

# So hipcc will do the right thing
export HIPCC_COMPILE_FLAGS_APPEND="--offload-arch=gfx90a" # $(CC --cray-print-opts=cflags)"
#export HIPCC_LINK_FLAGS_APPEND=$(CC --cray-print-opts=libs)

# So CMake can find MPI
export PE_PKGCONFIG_PRODUCTS=PE_MPICH
export PE_PKGCONFIG_LIBS=mpich
cc --cray-print-opts=all

# Configure
cmake -B build \
-DWITH_Kokkos=OFF \
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
