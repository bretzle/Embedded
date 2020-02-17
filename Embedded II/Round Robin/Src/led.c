/**
  ******************************************************************************
  * @file    led.c
  * @author  John Bretz
  * @version V1.0
  * @brief   LED api.
  ******************************************************************************
*/

#include "timer.h"

#define RCC_AHB1ENR (int *) 0x40023830
#define GPIOB_MODER (int *) 0x40020400
#define GPIOB_ODR (int *) 0x40020414

#define GPIOB_ENABLE 0x2

static TIM* tim3 = (TIM *) TIM3_BASE;
static int led_flag = 0;

void LED_INIT(void) {
	// turn on gpiob
	*RCC_AHB1ENR |= GPIOB_ENABLE;

	// set pb5-10, pb12-15 to output
	*GPIOB_MODER |=  0x55155400;
	*GPIOB_MODER &= ~0xAA2AA800;

	// setup timer
	init_tim3();
	enable_tim3_int(tim3);
	set_psc(tim3, 16000 - 1);
}

void light_LED(int number) {
	*GPIOB_ODR &= ~0xF7E0; // turn off all leds

	*GPIOB_ODR |= (number & 0x3F)  << 5; // bottom 6 bits
	*GPIOB_ODR |= (number & 0x3C0) << 6; // top 4 bits
}

void light(int led, int status) {
	if (status) {
		// enable
		*GPIOB_ODR |= ((1 << led) & 0x3F)  << 5; // bottom 6 bits
		*GPIOB_ODR |= ((1 << led) & 0x3C0) << 6; // top 4 bits
	} else {
		// disable
		*GPIOB_ODR &= ~(((1 << led) & 0x3F)  << 5); // bottom 6 bits
		*GPIOB_ODR &= ~(((1 << led) & 0x3C0) << 6); // top 4 bits
	}
}

void led_delay(void) {
	led_flag = 0;
	set_arr(tim3, 100);
	start(tim3);
	while (!led_flag);
}

void TIM3_IRQHandler(void) {
	tim3->SR &= ~1;
	stop(tim3);
	led_flag = 1;
}