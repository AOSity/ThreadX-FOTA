# CPU architecture and compiler flags
set(CPU_FLAGS "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard")

# ThreadX port
set(THREADX_ARCH cortex_m7)
set(THREADX_TOOLCHAIN gnu)

# STM32 chip macro
set(STM32_CHIP_DEF STM32F767xx)

# Linker script path
set(LINKER_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/STM32F767XX_FLASH.ld)

# Sources from generated Makefile
set(TARGET_SOURCES
    Core/Src/main.c
    Core/Src/gpio.c
    Core/Src/stm32f7xx_it.c
    Core/Src/stm32f7xx_hal_msp.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_cortex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc_ex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_flash.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_flash_ex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_gpio.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_dma.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_dma_ex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_pwr.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_pwr_ex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_i2c.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_i2c_ex.c
    Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_exti.c
    Core/Src/system_stm32f7xx.c
    startup_stm32f767xx.s
)
list(TRANSFORM TARGET_SOURCES PREPEND "${CMAKE_CURRENT_LIST_DIR}/")

# Includes from generated Makefile
set(TARGET_INCLUDES
    Core/Inc
    Drivers/STM32F7xx_HAL_Driver/Inc
    Drivers/STM32F7xx_HAL_Driver/Inc/Legacy
    Drivers/CMSIS/Device/ST/STM32F7xx/Include
    Drivers/CMSIS/Include
)
list(TRANSFORM TARGET_INCLUDES PREPEND "${CMAKE_CURRENT_LIST_DIR}/")
