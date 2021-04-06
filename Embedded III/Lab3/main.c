//! John Bretz
//! CE2820
//! main.c
//! Entrypoint
//!
//! Uses the switches to control the servos

#include <stdio.h>
#include <system.h>
#include "servo.h"

volatile int *switches = (volatile int *)SLIDER_SWITCHES_BASE;

int main()
{
	printf("Hello lab 3\n");

	char stored = -1;

	while (1)
	{
		char value = (char)(*switches & 0xFF);

		if (stored != value)
		{
			move_servo(SERVO_1, value);
			stored = value;
		}
	}

	return 0;
}
