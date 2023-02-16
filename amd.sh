export CXX=`which amdclang++`
export CC=`which amdclang`
export APEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# clean up
rm -rf build

# Configure
cmake -B build \

#-DCMAKE_CXX_COMPILER=`which amdclang++` \
#-DCMAKE_C_COMPILER=`which amdclang` \
#-DAPEX_ROOT=$HOME/src/xpress-apex/install_gilgamesh_5.2.0

# Build
cmake --build build -j