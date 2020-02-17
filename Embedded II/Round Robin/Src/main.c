/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Entry point and main logic.
  ******************************************************************************
*/

#include "robin.h"
#include "embedded.h"
#include "timer.h"

static TIM* tim2 = (TIM *) TIM2_BASE;
static TIM* tim3 = (TIM *) TIM3_BASE;

static int led_flag = 0;

void delay_ms(int);
void SysTick_Init();

void t1() {
	int number = 1;
	init_tim3();
	enable_tim3_int(tim3);
	tim3->PSC = 16000 - 1;

	while (1) {
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			delay_ms(100);
			number = number << 1;
		}
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			delay_ms(100);
			number = number >> 1;
		}
	}
}

void t2() {
	while (1);
}

void t3() {
	while (1);
}

int main(void) {
	init_tasker(4, 10);
	init_task(1, 1000, t1, 50);
	init_task(2, 1000, t2, 50);
	init_task(3, 1000, t3, 50);

	LED_INIT();
	SysTick_Init();

	while(1);
}

#define STK_BASE (int *) 0xE000E010
#define STK_CLK_SOURCE (int *) 0xE000E012
#define STK_LOAD (int *) 0xE000E014


void SysTick_Init() {
	*STK_BASE = 0;       // disable clock
	*STK_CLK_SOURCE = 0; // use system clock
	*STK_LOAD = 100;     // set delay
	*STK_BASE |= 1 << 1; // enable interrupt
	*STK_BASE |= 1;      // enable the clock.
}

void SysTick_Handler(void) {
	tasker_tick();
}

void delay_ms(int number) {
	led_flag = 0;
	set_arr(tim3, number);
	start(tim3);
	while (!led_flag);
}

void TIM3_IRQHandler(void) {
	tim3->SR &= ~1;
	stop(tim3);
	led_flag = 1;
}
