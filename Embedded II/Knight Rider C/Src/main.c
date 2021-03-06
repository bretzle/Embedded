/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Entry point and main logic.
  ******************************************************************************
*/

#include <stdio.h>
#include <stdlib.h>
#include "embedded.h"

#define delay 100

int main(void) {

	LED_INIT();

	int number = 1;

	while (1) {
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			delay_ms(delay);
			number = number << 1;
		}
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			delay_ms(delay);
			number = number >> 1;
		}
	}
}

