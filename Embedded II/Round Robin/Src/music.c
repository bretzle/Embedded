/**
  ******************************************************************************
  * @file    music.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Allows the playing of music.
  ******************************************************************************
*/

#include "music.h"
#include "timer.h"
#include "register.h"
#include <stdio.h>

static int* RCC = (int*) RCC_BASE;
static int* GPIOB = (int*) GPIOB_BASE;

static TIM *tim3 = (TIM*) TIM3_BASE;
static TIM *tim10 = (TIM*) TIM10_BASE;

static NOTE* start_of_song;

void init_music(void) {
    // Setup timers
    init_tim3();
    init_tim10();
    set_psc(tim10, 830);
    enable_tim10_int(tim10);

    // Have tim3 use Output Compare
    tim3->CCR1 = 0;
    tim3->CCMR1 = (0b011<<4);
    tim3->CCER = 1;

    // setup speaker
    RCC[AHB1ENR] |= GPIOBEN;
    GPIOB[AFRL] |= (0b0010<<16);
    GPIOB[MODER] |= (0b10<<8);
}

void start_song(void) {
    start_of_song = cur_song;
    if (cur_song->freq != 0 && cur_song->len != 0) {
        start(tim10);
    } else {
        printf("Cannot start the song. Try running replay instead.");
    }
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

// Sets the frequency of the next Note
static void change_freq(int freq) {
    set_arr(tim3, freq);
}

// Sets the duration of the next Note
static void change_delay(int len) {
    set_arr(tim10, len);
}

// Handles interrupt for Timer 10. Interrupt fires whenever a note has finished playing
void TIM1_UP_TIM10_IRQHandler(void) {
    tim10->SR &= ~1;

    stop(tim10);
    stop(tim3);

    // Add a bit of delay between notes
    for (int i=0; i<1500; i++);

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