#add_compile_options(-Wall -Wextra -pedantic -Werror)

add_executable(complex_mult complex_mult.cpp)
include_directories(${CMAKE_SOURCE_DIR}/oneAPI-samples/common)
target_link_libraries (complex_mult pthread sycl)
target_compile_options(complex_mult PUBLIC -fsycl)
add_dependencies (tutorial.tests complex_mult)
add_test (NAME test_complex_mult COMMAND ${APEX_ROOT}/bin/apex_exec --apex:level0 ${CMAKE_BINARY_DIR}/bin/complex_mult)

