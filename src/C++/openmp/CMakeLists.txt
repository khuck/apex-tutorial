set(example_programs
    ompt_target_daxpy
    ompt_target_matmult
   )

foreach(example_program ${example_programs})
    set(sources ${example_program}.cpp)

    source_group("Source Files" FILES ${sources})

    add_executable(${example_program} ${sources})
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVHPC")
        # Use the tool-enabled OpenMP runtime
        target_compile_options(${example_program} PRIVATE -mp=ompt -fopenmp-targets=nvptx64-nvidia-cuda)
        target_link_options(${example_program} PRIVATE -mp=ompt -fopenmp-targets=nvptx64-nvidia-cuda)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        target_compile_options(${example_program} PRIVATE -qnextgen -fiopenmp -fopenmp-targets=spir64)
        target_link_options(${example_program} PRIVATE -qnextgen -fiopenmp -fopenmp-targets=spir64)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        target_compile_options(${example_program} PRIVATE -fopenmp -target x86_64-pc-linux-gnu -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a)
        target_link_options(${example_program} PRIVATE -fopenmp -target x86_64-pc-linux-gnu -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a)
    else()
        target_link_libraries (${example_program} OpenMP::OpenMP_CXX)
    endif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVHPC")
    add_dependencies (tests ${example_program})
    add_test ("test_${example_program}" ${example_program})
endforeach()

