
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(kokkos_thread_teams thread_teams.cpp)
target_link_libraries (kokkos_thread_teams Kokkos::kokkos)
add_dependencies (tests kokkos_thread_teams)
add_test (NAME test_kokkos_thread_teams COMMAND kokkos_thread_teams)

