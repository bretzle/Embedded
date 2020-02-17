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
#include "lcd.h"
#include "keypad.h"

void t1() {
	int number = 1;

	while (1) {
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			led_delay();
			number = number << 1;
		}
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			led_delay();
			number = number >> 1;
		}
	}
}

void t2() {
	lcd_init();
	keypad_init();

	while(1) {
		char letter = keypad_getchar();

		switch (letter) {
			case '*':
				lcd_clear();
				break;
			case '#':
				lcd_home();
				break;
			default:
				lcd_print_char(letter);
				break;
		}
	}
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
