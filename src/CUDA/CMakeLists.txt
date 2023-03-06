enable_language(CUDA)

set(example_programs
    apex_vector
    multiGpuThread
   )

if (OPENMP_FOUND)
  set(example_programs "${example_programs};pi")
endif (OPENMP_FOUND)

message(INFO "Using CUDA libraries: ${CUDA_LIBRARIES}")

set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS} ${APEX_CUDA_C_FLAGS}")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS} ${APEX_CUDA_CXX_FLAGS}")

foreach(example_program ${example_programs})
  set(sources ${example_program}.cu)
  source_group("Source Files" FILES ${sources})
  add_executable("${example_program}_cu" ${sources})
  target_link_libraries ("${example_program}_cu" apex ${LIBS} OpenMP::OpenMP_CXX CUDA::cuda_driver curand nvToolsExt ${APEX_CUDA_CXX_LINK_FLAGS})
  add_dependencies (tests "${example_program}_cu")
  add_test (NAME "test_${example_program}_cu" COMMAND "${example_program}_cu")
  install(TARGETS "${example_program}_cu" RUNTIME DESTINATION "bin" OPTIONAL)
  #set_tests_properties("test_${example_program}_cu" PROPERTIES ENVIRONMENT "APEX_ENABLE_CUDA=1;APEX_CUDA_KERNEL_DETAILS=1;APEX_CUDA_COUNTERS=1;APEX_CUDA_DRIVER_API=1")

endforeach()


