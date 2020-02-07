#include "music.h"
#include "main.h"
#include "timing.h"

#define F_CPU 16000000

static void tone(int, int);

TIM_HandleTypeDef htim3;
TIM_HandleTypeDef htim10;

static NOTE* song;

void play_song(NOTE* score) {
    song = score;

//    HAL_TIM_Base_Start_IT(&htim10);

	 while (score->len != 0) {
	 	tone(score->freq, score->len);
	 	score++;
	 }
}

static void tone(int freq, int duration) {
    int arr_val = freq != 0 ? 16000000 / (2 * freq) : 0;

    change_freq(arr_val);
    HAL_TIM_OC_Start(&htim3, TIM_CHANNEL_1);
    delay_ms(duration);
    HAL_TIM_OC_Stop(&htim3, TIM_CHANNEL_1);
    delay_ms(10);
}

void change_freq(int freq) {
    htim3.Init.Period = freq;
    HAL_TIM_OC_Init(&htim3);
}

void change_delay(int len) {
    htim10.Init.Period = len;
    HAL_TIM_OC_Init(&htim10);
}

void TIM1_UP_TIM10_IRQHandler(void) {
    HAL_TIM_IRQHandler(&htim10);

    HAL_TIM_Base_Stop_IT(&htim10);
    HAL_TIM_OC_Stop(&htim3, TIM_CHANNEL_1);

    if (song->len != 0) {
        int freq = song->freq;
        int len = song->len;

        int arr_val = freq != 0 ? 16000000 / (2 * freq) : 0;

        change_freq(arr_val);
        change_delay(len * (F_CPU / 8000));

        HAL_TIM_OC_Start(&htim3, TIM_CHANNEL_1);
        HAL_TIM_Base_Start_IT(&htim10);

        song++;
    }
}
