# apex-tutorial
Tutorial examples for APEX (https://github.com/UO-OACISS/apex)
To follow the tutorial, see https://github.com/khuck/apex-tutorial/wiki

This repository contains a number of examples for demonstrating
 - APEX model support
 - APEX measurement support
 - APEX policy support

To build the tutorial examples, see the specific system examples,
or manually build with:

```
export APEX_ROOT=$HOME/src/apex/install
# Configure
cmake -B build
# Build
cmake --build build -j
# Test
ctest --test-dir build
```

For clues on which Kokkos architectures are available, see
`kokkos/cmake/kokkos_arch.cmake`.
(https://github.com/kokkos/kokkos/blob/master/cmake/kokkos_arch.cmake)

# Example system build instructions:
## Lumi
```
# load the AMD compilers
module swap PrgEnv-cray PrgEnv-amd/8.3.3
# load cmake
ml CrayEnv
ml buildtools/22.08
# load python for analysis tools
ml cray-python
# load ROCm
ml rocm

export APEX_ROOT=$HOME/install/apex
# These settings help the (broken?) version of CMake on lumi find the Cray MPI flags when cc/CC/ftn are not the compilers 
export PE_PKGCONFIG_PRODUCTS=PE_MPICH
export PE_PKGCONFIG_LIBS=mpich

# clean up
rm -rf build

# Configure
cmake -B build \
-DCMAKE_CXX_COMPILER=`which hipcc` \
-DCMAKE_C_COMPILER=`which amdclang` \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
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
```
