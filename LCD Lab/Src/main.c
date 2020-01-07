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
