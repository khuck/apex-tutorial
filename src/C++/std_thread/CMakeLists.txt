include_directories(${CMAKE_SOURCE_DIR}/src/C++/common)
add_compile_options(-Wall -Wextra -pedantic -Werror)

add_executable(std_thread_cpp std_thread.cpp)
target_link_libraries (std_thread_cpp pthread)
add_dependencies (tests std_thread_cpp)
add_test (test_std_thread_cpp std_thread_cpp)

add_executable(apex_std_thread_cpp apex_std_thread.cpp)
target_link_libraries (apex_std_thread_cpp ${LIBS})
add_dependencies (tests apex_std_thread_cpp)
add_test (test_apex_std_thread_cpp apex_std_thread_cpp)

add_executable(apex_deps_std_thread_cpp apex_deps_std_thread.cpp)
target_link_libraries (apex_deps_std_thread_cpp ${LIBS})
add_dependencies (tests apex_deps_std_thread_cpp)
add_test (test_apex_deps_std_thread_cpp apex_deps_std_thread_cpp)

