add_compile_options(-Wall -Wextra -pedantic -Werror)

add_executable(MatrixTranspose MatrixTranspose.cpp)
target_link_libraries (MatrixTranspose ${LIBS})
add_dependencies (tests MatrixTranspose)
add_test (test_MatrixTranspose MatrixTranspose)

