/**
  ******************************************************************************
  * @file    led.c
  * @author  John Bretz
  * @version V1.0
  * @brief   LED api.
  ******************************************************************************
*/

#define RCC_AHB1ENR (int *) 0x40023830
#define GPIOB_MODER (int *) 0x40020400
#define GPIOB_ODR (int *) 0x40020414

#define GPIOB_ENABLE 0x2

void LED_INIT(void) {
	// turn on gpiob
	*RCC_AHB1ENR |= GPIOB_ENABLE;

	// set pb5-10, pb12-15 to output
	*GPIOB_MODER |=  0x55155400;
	*GPIOB_MODER &= ~0xAA2AA800;
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
