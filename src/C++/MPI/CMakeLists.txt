# Make sure that spaces in linker lines don't cause CMake errors
#if (POLICY CMP0004)
#  cmake_policy(SET CMP0004 OLD)
#endif()

# Add executable called "lulesh_MPI_OpenMP_2.0" that is built from the source file
# "lulesh.cc". The extensions are automatically found.
add_executable (lulesh_MPI_OpenMP_2.0 lulesh.cc lulesh-comm.cc lulesh-init.cc lulesh-util.cc lulesh-viz.cc  synchronous_policy.cpp)

# Link the executable
target_link_libraries(lulesh_MPI_OpenMP_2.0 APEX::apex MPI::MPI_CXX OpenMP::OpenMP_CXX stdc++)

#add_test (test_lulesh_MPI_OpenMP_2.0 ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} 8
#      ${MPIEXEC_PREFLAGS} ${APEX_ROOT}/bin/apex_exec ${CMAKE_BINARY_DIR}/bin/lulesh_MPI_OpenMP_2.0 -p -i 100
#      -s 15 ${MPIEXEC_POSTFLAGS})

