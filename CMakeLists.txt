cmake_minimum_required(VERSION 3.20)

# set the project name and version
project(Tutorial VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
find_package(APEX REQUIRED)

include_directories(${APEX_INCLUDE_DIRS})
set(LIBS ${LIBS} ${APEX_LIBRARIES} pthread)

add_subdirectory(src/C++/std_thread)

