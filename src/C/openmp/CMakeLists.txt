set(example_programs
    ompt_thread
    ompt_parallel_region
    ompt_reduction
    ompt_task
    ompt_single
    ompt_sections
    ompt_sync_region_wait
    ompt_master
   )

foreach(example_program ${example_programs})
    set(sources ${example_program}.c)

    source_group("Source Files" FILES ${sources})

    add_executable(${example_program} ${sources})
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVHPC")
        # Use the tool-enabled OpenMP runtime
        target_compile_options(${example_program} PRIVATE "-mp=ompt")
        target_link_options(${example_program} PRIVATE "-mp=ompt")
    else()
        target_link_libraries (${example_program} OpenMP::OpenMP_C)
    endif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVHPC")
    add_dependencies (tests ${example_program})
    add_test (NAME "test_${example_program}" COMMAND ${example_program})
endforeach()

