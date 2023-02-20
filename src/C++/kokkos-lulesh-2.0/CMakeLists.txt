
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(kokkos_lulesh_2.0 lulesh.cc  lulesh-comm.cc  lulesh-init.cc  lulesh-util.cc  lulesh-viz.cc)
target_link_libraries (kokkos_lulesh_2.0 Kokkos::kokkos)
add_dependencies (tests kokkos_lulesh_2.0)
add_test (test_kokkos_lulesh_2.0 kokkos_lulesh_2.0)

