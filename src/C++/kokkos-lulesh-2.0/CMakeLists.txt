
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(kokkos_lulesh_2.0 lulesh.cc  lulesh-comm.cc  lulesh-init.cc  lulesh-util.cc  lulesh-viz.cc)
target_link_libraries (kokkos_lulesh_2.0 Kokkos::kokkos)
add_dependencies (tutorial.tests kokkos_lulesh_2.0)
add_test (NAME test_kokkos_lulesh_2.0 COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_lulesh_2.0)

