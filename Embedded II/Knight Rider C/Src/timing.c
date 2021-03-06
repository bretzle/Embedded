/**
  ******************************************************************************
  * @file    timing.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Timing api.
  ******************************************************************************
*/


#define STK_BASE (int *) 0xE000E010
#define STK_CLK_SOURCE (int *) 0xE000E012
#define STK_LOAD (int *) 0xE000E014

#define COUNT_FLAG 1<<16
#define freq 16000000UL

void delay_ms(int delay) {

	*STK_BASE = 0;                     // disable clock
	*STK_CLK_SOURCE = 0;               // use system clock
	*STK_LOAD = delay * (freq / 8000); // set delay
	*STK_BASE = 1;                     // enable the clock.

	while (!(*STK_BASE & (1 << 16))) {
		// busy wait
	}

	*STK_BASE = 0; // disable clock
}
