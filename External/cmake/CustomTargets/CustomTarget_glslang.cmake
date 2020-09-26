
get_filename_component(GLSLANG_DIR ${COMPRESSONATOR_PROJECT_DIR}/External/vulkan/vulkan-submodule/${CMAKE_SYSTEM_NAME}/glslang ABSOLUTE)

set(GLSLANG_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/glslang)
file(MAKE_DIRECTORY ${GLSLANG_BUILD_DIR})

if(${shared})
    set(OUTPUT_EXTENSION ".dll")
else()
    set(OUTPUT_EXTENSION ".lib")
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(GLSLANG_INSTALL_PREFIX ${GLSLANG_INSTALL_PREFIX}d)
    set(GLSLANG_OUTPUTS ${DEPENDENCIES_INSTALL_DIR}/lib/glslangd${OUTPUT_EXTENSION})
else()
    set(GLSLANG_OUTPUTS ${DEPENDENCIES_INSTALL_DIR}/lib/glslang${OUTPUT_EXTENSION})
endif()

add_custom_command(OUTPUT ${GLSLANG_OUTPUTS}
    PRE_BUILD

    COMMENT "Compiling Glslang"

    WORKING_DIRECTORY ${GLSLANG_BUILD_DIR}
    COMMAND ${CMAKE_COMMAND} ${GLSLANG_DIR}
            -DCMAKE_BUILD_TYPE:STRING=${type}
            -DBUILD_SHARED_LIBS:BOOL=${shared}
            -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING="${CMAKE_MSVC_RUNTIME_LIBRARY}"
            -DCMAKE_INSTALL_PREFIX:STRING=${DEPENDENCIES_INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel ${NUM_PARALLEL_JOBS}
        COMMAND ${CMAKE_COMMAND} --install . --config ${CMAKE_BUILD_TYPE}
)

add_custom_target(glslang

    DEPENDS ${GLSLANG_OUTPUTS}
)