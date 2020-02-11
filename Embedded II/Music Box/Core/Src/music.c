#include "music.h"
#include "main.h"
#include "timing.h"
#include "stm32f446xx.h"
#include "uart_driver.h"

extern TIM_HandleTypeDef htim3;
extern TIM_HandleTypeDef htim10;

void change_freq(int freq) {
    htim3.Init.Period = freq;
    HAL_TIM_OC_Init(&htim3);
}

void change_delay(int len) {
    htim10.Init.Period = len;
    HAL_TIM_Base_Init(&htim10);
}

static int num = 1;

static int* tim10 = (int *) 0x4001442C;

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) {
    if (htim == &htim10) {
         HAL_TIM_Base_Stop_IT(&htim10);
        HAL_TIM_OC_Stop(&htim3, TIM_CHANNEL_1);

        if (cur_song->len != 0) {
            int freq = cur_song->freq;
            int len = cur_song->len;

            int arr_val = freq != 0 ? 16000000 / (2 * freq) : 0;
            int del = len * 20;

            change_freq(arr_val);
//            change_delay(del);
            *tim10 = del;

//            printf("%d", num);
//            num++;

            HAL_TIM_OC_Start(&htim3, TIM_CHANNEL_1);
             HAL_TIM_Base_Start_IT(&htim10);

            cur_song++;
        }
    }
}
