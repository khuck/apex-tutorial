# apex-tutorial
Tutorial examples for APEX (https://github.com/UO-OACISS/apex)

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
export APEX_ROOT=$HOME/install/apex

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
