export CXX=`which clang++`
export CC=`which clang`
export APEX_ROOT=$HOME/src/apex/install

# clean up
rm -rf build

# Configure
cmake -B build \
 -DKokkos_ENABLE_PTHREAD=ON

#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j
ctest --test-dir build