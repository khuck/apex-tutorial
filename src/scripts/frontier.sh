#!/bin/bash -e

#module reset
module load ums ums002
module load apex/amd_rocm_5.7.1
export CXX=`which hipcc`
export CC=`which amdclang`
#export APEX_ROOT=$HOME/src/apex/crusher/install

builddir=frontier/build
# clean up
rm -rf ${builddir}

# Configure
cmake -B ${builddir} \
-DCMAKE_BUILD_TYPE=Debug \
-DWITH_Kokkos=ON \
-DWITH_KokkosKernels=OFF \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_HIP=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_VEGA90A=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkosKernels_ENABLE_EXAMPLES=ON \
-DROCTX_ROOT=/opt/rocm-5.7.1/roctracer \


#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build ${builddir} -j
ctest --test-dir ${builddir}
