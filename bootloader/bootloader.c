/**
 * @file bootloader.c
 *
 * @author Andrii Horbul
 */

#include "main.h"

/**
 * @brief 
 * 
 */
void jump_to_application(void) {
    uint32_t app_sp = *(volatile uint32_t*)APP_START_ADDR;
    uint32_t app_pc = *(volatile uint32_t*)(APP_START_ADDR + 4);

    HAL_DeInit();
    __set_MSP(app_sp);

    void (*app_reset_handler)(void) = (void*)app_pc;
    app_reset_handler();
}

/**
 * @brief Post init process
 *
 */
void init_complete_handler() {
    jump_to_application();
    while (1) {
    }
}
