
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(kokkos_thread_teams thread_teams.cpp)
target_link_libraries (kokkos_thread_teams Kokkos::kokkos stdc++)
add_dependencies (tutorial.tests kokkos_thread_teams)
add_test (NAME test_kokkos_thread_teams COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_thread_teams)

add_executable(kokkos_nested nested.cpp)
target_link_libraries (kokkos_nested Kokkos::kokkos stdc++)
add_dependencies (tutorial.tests kokkos_nested)
add_test (NAME test_kokkos_nested COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_nested)

