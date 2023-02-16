export CXX=`which amdclang++`
export CC=`which amdclang`
export APEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# clean up
rm -rf build

# Configure
cmake -B build \
-DKokkos_ENABLE_OPENMP=ON \
-DKokkos_ENABLE_HIP=ON \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ARCH_ZEN2=ON \
-DKokkos_ARCH_VEGA90A=ON \
-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
-DKokkos_ENABLE_TESTS=OFF \


#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j
ctest --test-dir build