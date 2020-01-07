/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Default main function.
  ******************************************************************************
*/

#include "lcd.h"
#include "keypad.h"
#include "timing.h"

int main(void) {
//	return just_lcd();
	return with_keypad();
}

int just_lcd() {
	lcd_init();

	while (1) {
		lcd_print_string("Start");
		lcd_set_position(1, 3);
		lcd_print_string("Counter!");
		delay_ms(1000);

		lcd_clear();
		lcd_home();

		int time = 10;
		for (int i = 0; i < 10; i++) {
			lcd_print_num(time);
			delay_ms(1000);
			lcd_clear();
			lcd_home();
			time--;
		}

		lcd_print_string("Finished!");
		delay_ms(1000);
		lcd_clear();
		lcd_home();
	}
	return 0;
}

int with_keypad() {
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

	return 0;
}
