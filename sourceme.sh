export APEX_ROOT=${HOME}/src/apex/install
export PATH=${APEX_ROOT}/bin:${PATH}

export CXX=`which clang++`
export CC=`which clang`

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads