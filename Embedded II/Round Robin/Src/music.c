#include "music.h"
#include "timer.h"
#include "register.h"

static TIM *tim3 = (TIM *)TIM3_BASE;
static TIM *tim10 = (TIM *)TIM10_BASE;

static NOTE* start_of_song;

void init_music(void) {
    init_tim3();
    init_tim10();
    enable_tim10_int(tim10);

    // set tim3 to OC
    tim3->CCR1 = 0;
    tim3->CCMR1 = (0b011<<4);
    tim3->CCER = 1;

    // setup speaker
    int* RCC = (int*) RCC_AHB1ENR;
    *RCC |= GPIOBEN;
    int* GPIOB = (int*) GPIOB_BASE;
    // enable alternate function
    GPIOB[AFRL] |= (0b0010<<16);
    // set pin to alternate function
    GPIOB[MODER] |= (0b10<<8);


    set_psc(tim10, 830);
}

void start_song(void) {
    start_of_song = cur_song;
    start(tim10);
}

void pause(void) {
    stop(tim3);
    stop(tim10);
}

void resume(void) {
    start(tim3);
    start(tim10);
}

void replay(void) {
    stop(tim3);
    stop(tim10);
    cur_song = start_of_song;
    start(tim3);
    start(tim10);
}

static void change_freq(int freq) {
    set_arr(tim3, freq);
}

static void change_delay(int len) {
    set_arr(tim10, len);
}

void TIM1_UP_TIM10_IRQHandler(void) {
    tim10->SR &= ~1;

    stop(tim10);
    stop(tim3);

    if (cur_song->len != 0) {
        int freq = cur_song->freq;
        int len = cur_song->len;

        int arr_val = freq != 0 ? 16000000 / (2 * freq) : 0;
        int del = len * 20;

        // change note frequency
        change_freq(arr_val);

        // change note duration
        change_delay(del);

        // startup the timers
        start(tim3);
        start(tim10);

        // inc pointer
        cur_song++;
    }
}