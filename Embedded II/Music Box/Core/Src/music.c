#include "music.h"
#include "main.h"
#include "timing.h"

static void tone(int, int);

TIM_HandleTypeDef htim3;

void play_song(NOTE* score) {
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
