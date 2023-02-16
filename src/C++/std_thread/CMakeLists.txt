
add_executable(std_thread_cpp std_thread.cpp)
target_link_libraries (std_thread_cpp pthread)
add_executable(apex_std_thread_cpp apex_std_thread.cpp)
target_link_libraries (apex_std_thread_cpp ${LIBS})
