//! John Bretz
//! CE2820
//! switches.h
//! switches api impl

#include "system.h"

static volatile int * SWITCHES = (volatile int *) SLIDER_SWITCHES_BASE;

int read_switches(void)
{
	return *SWITCHES & 0x3FF;
}
