
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(kokkos_thread_teams thread_teams.cpp)
target_link_libraries (kokkos_thread_teams Kokkos::kokkos)
add_dependencies (tutorial.tests kokkos_thread_teams)
add_test (NAME test_kokkos_thread_teams COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_thread_teams)

add_executable(kokkos_exercise_mdrange exercise_mdrange.cpp)
target_link_libraries (kokkos_exercise_mdrange Kokkos::kokkos)
add_dependencies (tutorial.tests kokkos_exercise_mdrange)
add_test (NAME test_kokkos_exercise_mdrange COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_exercise_mdrange)

add_executable(kokkos_exercise_teams exercise_teams.cpp)
target_link_libraries (kokkos_exercise_teams Kokkos::kokkos)
add_dependencies (tutorial.tests kokkos_exercise_teams)
add_test (NAME test_kokkos_exercise_teams COMMAND ${APEX_ROOT}/bin/apex_exec --apex:kokkos ${CMAKE_BINARY_DIR}/bin/kokkos_exercise_teams)

