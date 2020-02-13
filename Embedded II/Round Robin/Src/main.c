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

int count_flags[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};

static TIM* tim1 = (TIM *) TIM1_BASE;

static int* RCC_APB2ENR = (int*) 0x40023844;

void delay_ms(int);
void SysTick_Init();

void t1() {
	int number = 1;

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
#define NVIC (int *) 0x

#define COUNT_FLAG 1<<16
#define freq 16000000UL

void SysTick_Init() {
	*STK_BASE = 0;       // disable clock
	*STK_CLK_SOURCE = 0; // use system clock
	*STK_LOAD = 100;     // set delay
	*STK_BASE |= 1 << 1; // enable interrupt
	*STK_BASE |= 1;      // enable the clock.
}

void init_tim1(void) {
	*RCC_APB2ENR |= 1; // enable RCC
	tim1->DIER |= 1<<6; // enable trigger interrupt
}

void SysTick_Handler(void) {
	tasker_tick();
}

void delay_ms(int number) {
	number = calc_brute_delay(number);
	for (int i=0; i<number; i++);
}
