cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(FOTA C ASM)

# Load toolchain
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/arm-none-eabi-toolchain.cmake")

# Allow board to be chosen
if(NOT DEFINED TARGET_BOARD)
    set(TARGET_BOARD "NUCLEO-F767ZI")
endif()
message(STATUS "Building for target: ${TARGET_BOARD}")

# Paths
set(TARGET_PATH ${CMAKE_SOURCE_DIR}/target/${TARGET_BOARD})
set(SOURCE_PATH ${CMAKE_SOURCE_DIR}/source)
set(THREADX_PATH ${CMAKE_SOURCE_DIR}/third-party/threadx)
set(NETXDUO_PATH ${CMAKE_SOURCE_DIR}/third-party/netxduo)

# Output binary location
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Include target-specific config
include(${TARGET_PATH}/target.cmake)
include(${TARGET_PATH}/target_config.cmake)

# Set compiler flags based on CPU_FLAGS from board
set(CMAKE_C_FLAGS "${CPU_FLAGS} -g3 -O0 -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_ASM_FLAGS "${CPU_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT} -Wl,-Map=${TARGET_BOARD}.map,--gc-sections")

# Main application
add_executable(${TARGET_BOARD}.elf
    ${TARGET_SOURCES}
    ${SOURCE_PATH}/main.c
)

target_include_directories(${TARGET_BOARD}.elf PRIVATE
    ${TARGET_INCLUDES}
    ${SOURCE_PATH}
)

target_compile_definitions(${TARGET_BOARD}.elf PRIVATE
    ${TARGET_DEFS}
)

# Third-party components
add_subdirectory(${THREADX_PATH} EXCLUDE_FROM_ALL)
set(NXD_ENABLE_FILE_SERVERS OFF CACHE BOOL "Disable file servers from NetX Duo")
add_subdirectory(${NETXDUO_PATH} EXCLUDE_FROM_ALL)

target_link_libraries(${TARGET_BOARD}.elf
    threadx
    netxduo
)

# Convert to .bin
add_custom_command(TARGET ${TARGET_BOARD}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.elf
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.bin
    COMMENT "Generating .bin file"
)
