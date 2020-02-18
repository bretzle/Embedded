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

static TIM* tim2 = (TIM *) TIM2_BASE;
static int led_flag = 0;

void LED_INIT(void) {
	// turn on gpiob
	*RCC_AHB1ENR |= GPIOB_ENABLE;

	// set pb5-10, pb12-15 to output
	*GPIOB_MODER |=  0x55155400;
	*GPIOB_MODER &= ~0xAA2AA800;

	// setup timer
	init_tim2();
	enable_tim2_int(tim2);
	set_psc(tim2, 16000 - 1);
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
	set_arr(tim2, 100);
	start(tim2);
	while (!led_flag);
}

void TIM2_IRQHandler(void) {
	tim2->SR &= ~1;
	stop(tim2);
	led_flag = 1;
}