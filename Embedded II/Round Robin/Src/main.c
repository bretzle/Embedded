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
/// Console uses no Timer
/// Music Box uses Timer 3 and 10
///
/// Run the help command to see available commands

#include "robin.h"
#include "led.h"
#include "timer.h"
#include "lcd.h"
#include "keypad.h"
#include "uart_driver.h"
#include "music.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int read_mem(int);
void write_mem(int, int);
void dump_mem(int, int);
int check_addr(int);
void help(void);

NOTE* cur_song;

NOTE imperial_march[] = {
	{A3, QU},
	{A3, QU},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},
	{E4, QU},
	{E4, QU},
	{E4, QU},
	{F4, E + S},
	{C4, S},
	{Ab3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},
	{A4, QU},
	{A3, E + S},
	{A3, S},
	{A4, QU},
	{Ab4, E + S},
	{G4, S},
	{Gb4, S},
	{E4, S},
	{F4, E},

	{0, E + S},

	{Bb3, E},
	{Eb4, QU},
	{D4, E + S},
	{Db4, S},
	{C4, S},
	{B3, S},
	{C4, E},

	{0, E},

	{F3, E},
	{Ab3, QU},
	{F3, E + S},
	{A3, S},
	{C4, QU},
	{A3, E + S},
	{C4, S},
	{E4, H},
	{A4, QU},
	{A3, E + S},
	{A3, S},
	{A4, QU},
	{Ab4, E + S},
	{G4, S},
	{Gb4, S},
	{E4, S},
	{F4, E},

	{0, E},

	{Bb3, E},
	{Eb4, QU},
	{D4, E + S},
	{Db4, S},
	{C4, S},
	{B3, S},
	{C4, E},

	{0, E},

	{F3, E},
	{Ab3, QU},
	{F3, E + S},
	{C4, S},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},

	NOTE_END,
};

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

// Console
void t3() {
	char input[30];
	char cmd[5];
	int address, len, val;

	while (1) {
		fgets(input, 30, stdin); // gets input from console.

		if (starts_with(input, "rm")) {
			sscanf(input, "%s %x", cmd, &address); // fetch data from input.
    		if (check_addr(address)) {
    	    	int value = read_mem((uint32_t)address);
    	    	printf("0x%x\n", value);
    	  	}
		} else if (starts_with(input, "wm")) {
			val = 0;
    		sscanf(input, "%s %x %x", cmd, &address, &val); // fetch data from input.
    		if (check_addr(address)) {
    			write_mem(address, val);
    			printf("write 0x%x with 0x%x\n", address, val);
    		}
		} else if (starts_with(input, "dm")) {
			sscanf(input, "%s %x %d", cmd, &address, &len); // fetch data from input.
    		// Determine if the length is reasonable.
    		if (len > 100 || len < 0) {
    			len = 16;
    		}
    		if (check_addr(address)) {
    			dump_mem(address, len);
    			printf("\n");
    		}
		} else if (starts_with(input, "play")) {
			start_song();
		} else if (starts_with(input, "pause")) {
			pause();
		} else if (starts_with(input, "resume")) {
			resume();
		} else if (starts_with(input, "replay")) {
			replay();
		} else if (starts_with(input, "help")) {
			help();
		}
	}
}

// music box
void t4() {
	init_music();
	cur_song = imperial_march;

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
