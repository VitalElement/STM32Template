#include "Platform.h"
#include "stm32f4xx_hal.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

int main (void)
{
    Platform_Initialise ();

    while (1)
    {
        HAL_GPIO_TogglePin (LD3_GPIO_Port, LD3_Pin);

        HAL_Delay (100);

        HAL_GPIO_TogglePin (LD4_GPIO_Port, LD4_Pin);

        HAL_Delay (100);

        HAL_GPIO_TogglePin (LD5_GPIO_Port, LD5_Pin);

        HAL_Delay (100);

        HAL_GPIO_TogglePin (LD6_GPIO_Port, LD6_Pin);

        HAL_Delay (100);
    }
}
