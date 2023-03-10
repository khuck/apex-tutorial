include_directories(${CMAKE_SOURCE_DIR}/src/C++/common)
add_compile_options(-Wall -Wextra -pedantic -Werror)

add_executable(std_thread_cpp std_thread.cpp)
target_link_libraries (std_thread_cpp pthread stdc++)
add_dependencies (tutorial.tests std_thread_cpp)
add_test (NAME test_std_thread_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/std_thread_cpp)

add_executable(std_thread_inst_cpp std_thread.cpp)
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    target_compile_options(std_thread_inst_cpp PRIVATE -finstrument-functions -finstrument-functions-exclude-file-list=*.h,*.hpp -finstrument-functions-exclude-function-list=std::)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    target_compile_options(std_thread_inst_cpp PRIVATE -finstrument-functions)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    target_compile_options(std_thread_inst_cpp PRIVATE -finstrument-functions-after-inlining)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVHPC")
    target_compile_options(std_thread_inst_cpp PRIVATE -Minstrument)
endif()
target_link_libraries (std_thread_inst_cpp pthread stdc++)
add_dependencies (tutorial.tests std_thread_inst_cpp)
add_test (NAME test_std_thread_inst_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/std_thread_inst_cpp)

add_executable(apex_std_thread_cpp apex_std_thread.cpp)
target_link_libraries (apex_std_thread_cpp APEX::apex stdc++)
add_dependencies (tutorial.tests apex_std_thread_cpp)
add_test (NAME test_apex_std_thread_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/apex_std_thread_cpp)

add_executable(apex_deps_std_thread_cpp apex_deps_std_thread.cpp)
target_link_libraries (apex_deps_std_thread_cpp APEX::apex stdc++)
add_dependencies (tutorial.tests apex_deps_std_thread_cpp)
add_test (NAME test_apex_deps_std_thread_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/apex_deps_std_thread_cpp)

if(WITH_PerfStubs)
    add_executable(ps_std_thread ps_std_thread.cpp)
    target_link_libraries (ps_std_thread pthread perfstubs stdc++)
    add_dependencies (tutorial.tests ps_std_thread)
    add_test (NAME test_ps_std_thread COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/ps_std_thread)
    add_executable(apex_callstack_cpp apex_callstack.cpp)
    target_link_libraries (apex_callstack_cpp pthread perfstubs stdc++)
    add_dependencies (tutorial.tests apex_callstack_cpp)
    add_test (NAME test_apex_callstack_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/apex_callstack_cpp)

endif(WITH_PerfStubs)

add_executable(fibonacci_cpp fibonacci.cpp)
target_link_libraries (fibonacci_cpp pthread stdc++)
add_dependencies (tutorial.tests fibonacci_cpp)
add_test (NAME test_fibonacci_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/fibonacci_cpp)

add_executable(apex_fibonacci_cpp apex_fibonacci.cpp)
target_link_libraries (apex_fibonacci_cpp APEX::apex stdc++)
add_dependencies (tutorial.tests apex_fibonacci_cpp)
add_test (NAME test_apex_fibonacci_cpp COMMAND ${APEX_ROOT}/bin/apex_exec --apex:pthread ${CMAKE_BINARY_DIR}/bin/apex_fibonacci_cpp)


