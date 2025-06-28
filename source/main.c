/**
 * @file main.c
 * @brief device post init code
 *
 * @author Andrii Horbul
 */

#include "main.h"

/**
 * @brief Post init process
 *
 */
void init_complete_handler() {
    while (1) {
        HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
        HAL_Delay(500);
    }
}
