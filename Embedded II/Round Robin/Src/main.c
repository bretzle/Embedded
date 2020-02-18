/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Entry point and main logic.
  ******************************************************************************
*/

/// Each task get their own timer(s)
///
/// SysTick is reserved for the task switching
///
/// Knight Rider lights use Timer 2
/// LCD+keypad uses Timer 4
/// Memory Console uses no Timer
/// Music Box uses Timer 3 and 10

#include "robin.h"
#include "led.h"
#include "timer.h"
#include "lcd.h"
#include "keypad.h"
#include "uart_driver.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Controls lights
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

// controls lcd + keypad
void t2() {
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

// memory console
void t3() {
	char input[30]; // inputs from the user.
	char cmd[5];
	int address, len, val;

	while (1) {
		fgets(input, 30, stdin); // gets input from console.

    	/* Handle different commands */
    	switch (input[0]) {
    	// Read
    	case 'r':
    		sscanf(input, "%s %x", cmd, &address); // fetch data from input.
    		if (check_addr(address)) {
    	    	int value = read_mem((uint32_t)address);
    	    	printf("0x%x\n", value);
    	  	}
    	  	break;
    	// Write
    	case 'w':
    		val = 0;
    		sscanf(input, "%s %x %x", cmd, &address, &val); // fetch data from input.
    		if (check_addr(address)) {
    			write_mem(address, val);
    			printf("write 0x%x with 0x%x\n", address, val);
    		}
    		break;
    	// Dump
    	case 'd':
    		sscanf(input, "%s %x %d", cmd, &address, &len); // fetch data from input.
    		// Determine if the length is reasonable.
    		if (len > 100 || len < 0) {
    			len = 16;
    		}
    		if (check_addr(address)) {
    			dump_mem(address, len);
    			printf("\n");
    		}
    		break;
    	// help
    	case 'h':
    		help();
    		break;
    	// Invalid selection
    	default:
    		printf("Unknown command.\n");
    		help();
    	}
	}
}

// music box
void t4() {
	while (1);
}

int main(void) {
	init_tasker(5, 10);
	init_task(1, 1000, t1, 5);
	init_task(2, 1000, t2, 5);
	init_task(3, 1000, t3, 5);
	init_task(4, 1000, t4, 5);

	LED_INIT();
	lcd_init();
	keypad_init();
	init_usart2(19200, 16000000);
	SysTick_Init();

	while(1);
}
