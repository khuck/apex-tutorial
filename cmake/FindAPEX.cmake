# - Try to find APEX
# Input:
#  APEX_ROOT        - path to APEX installation
# Once done this will define
#  APEX_FOUND       - True if APEX found.
#  APEX_INCLUDE_DIR - where to find APEX.h, etc.
#  APEX_LIBRARIES   - List of libraries when using APEX.

if(NOT DEFINED $APEX_ROOT)
    if(DEFINED ENV{APEX_ROOT})
        set(APEX_ROOT $ENV{APEX_ROOT})
    endif()
endif()

find_path(APEX_INCLUDE_DIR apex_api.hpp HINTS ${APEX_ROOT}/include)

find_library(APEX_LIBRARY NAMES apex HINTS ${APEX_ROOT}/lib)

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set APEX_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(APEX DEFAULT_MSG
                                  APEX_LIBRARY APEX_INCLUDE_DIR)

mark_as_advanced(APEX_INCLUDE_DIR APEX_LIBRARY)

if (APEX_FOUND)
  set(APEX_LIBRARIES ${APEX_LIBRARY} )
  set(APEX_INCLUDE_DIRS ${APEX_INCLUDE_DIR})
  set(APEX_DIR ${APEX_ROOT})
  add_definitions(-DAPEX_HAVE_APEX)
  message(STATUS "Found APEX: ${APEX_LIBRARY}")
endif ()

