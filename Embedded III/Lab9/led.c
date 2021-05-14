//! John Bretz
//! CE2820
//! led.c
//! LED api impl

#include "system.h"
#include <stdint.h>

static volatile int *LEDS = (volatile int *)LEDS_BASE;

void write_leds(int16_t leds)
{
	*LEDS = leds & 0x7FF;
}
