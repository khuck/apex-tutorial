add_compile_options(-Wall -Wextra -pedantic -Werror)
include_directories(${ROCTX_INCLUDE_DIRS})

add_executable(MatrixTranspose MatrixTranspose.cpp)
target_link_libraries (MatrixTranspose ${ROCTX_LIBRARIES})
add_dependencies (tutorial.tests MatrixTranspose)
add_test (NAME test_MatrixTranspose COMMAND ${APEX_ROOT}/bin/apex_exec --apex:hip ${CMAKE_BINARY_DIR}/bin/MatrixTranspose)

