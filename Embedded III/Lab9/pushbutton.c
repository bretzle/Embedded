//! John Bretz
//! CE2820
//! pushbutton.c
//! pushbutton api impl

#include "system.h"

static volatile int* BUTTON_BASE = (volatile int *) PUSHBUTTONS_BASE;

int button_pressed(void)
{
	return *BUTTON_BASE & 0b11;
}

int is_button_pressed(int button)
{
	return *BUTTON_BASE & button;
}
