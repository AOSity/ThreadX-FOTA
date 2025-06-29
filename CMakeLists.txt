cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(FOTA C ASM)
message(STATUS "Building for target: ${TARGET_BOARD}, project: ${PROJECT}")

# Load toolchain
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/arm-none-eabi-toolchain.cmake")

# Paths
set(TARGET_PATH ${CMAKE_SOURCE_DIR}/target/${TARGET_BOARD})
set(APPLICATION_PATH ${CMAKE_SOURCE_DIR}/application)
set(BOOTLOADER_PATH ${CMAKE_SOURCE_DIR}/bootloader)
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

# Bootloader
if(PROJECT STREQUAL "boot")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${TARGET_PATH}/bootloader.ld -Wl,-Map=${TARGET_BOARD}.map,--gc-sections")
set(PROJECT_SOURCES
    ${BOOTLOADER_PATH}/bootloader.c
)
set(PROJECT_INCLUDES
    ${BOOTLOADER_PATH}
)
endif()

# Main application
if(PROJECT STREQUAL "app")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT} -Wl,-Map=${TARGET_BOARD}.map,--gc-sections")
set(PROJECT_SOURCES
    ${APPLICATION_PATH}/main.c
)
set(PROJECT_INCLUDES
    ${APPLICATION_PATH}
)
endif()

add_executable(${TARGET_BOARD}.elf
    ${TARGET_SOURCES}
    ${PROJECT_SOURCES}
)

target_include_directories(${TARGET_BOARD}.elf PRIVATE
    ${TARGET_INCLUDES}
    ${PROJECT_INCLUDES}
)

target_compile_definitions(${TARGET_BOARD}.elf PRIVATE
    ${TARGET_DEFS}
    ${FIRMWARE_UPDATE_DEFS}
)

# Third-party components
if(PROJECT STREQUAL "app")
add_subdirectory(${THREADX_PATH} EXCLUDE_FROM_ALL)
set(NXD_ENABLE_FILE_SERVERS OFF CACHE BOOL "Disable file servers from NetX Duo")
add_subdirectory(${NETXDUO_PATH} EXCLUDE_FROM_ALL)

target_link_libraries(${TARGET_BOARD}.elf
    threadx
    netxduo
)
endif()

# Convert .bin and .hex
add_custom_command(TARGET ${TARGET_BOARD}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.elf
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.elf
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_BOARD}.hex
    COMMENT "Generating .bin and .hex files"
)
