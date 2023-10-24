module load openmpi/4.1.1-rocm5.2.0

export APEX_ROOT=${HOME}/src/apex/install_gilgamesh_5.2.0
export PATH=${APEX_ROOT}/bin:${PATH}

export CXX=`which hipcc`
export CC=`which amdclang`

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

