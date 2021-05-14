//! John Bretz
//! CE2820
//! main.c
//! servo.c
//!
//! Implmentation of servo.h

#include <system.h>
#include "servo.h"

volatile int *SERVOS = (volatile int *)SERVOS_BASE;

static char deg_to_raw(char degree)
{
	float ret = (float)degree;
	ret = (ret / 90) * 200;
	return (char)ret;
}

void move_servo(char servo, char value)
{
	*SERVOS &= ~(((int)0xFF) << servo);
	*SERVOS |= ((int)value) << servo;
}

void move_servo_degree(char servo, char degree)
{
	*SERVOS &= ~(0xFF << servo);
	*SERVOS |= deg_to_raw(degree);
}

void move_servos(char raw_value_0, char raw_value_1)
{
	int raw0 = (int)raw_value_0;
	int raw1 = (int)raw_value_1;

	*SERVOS &= 0;
	*SERVOS |= (raw1 << SERVO_1) | raw0;
}

void move_servos_degree(char degree_0, char degree_1)
{
	int raw0 = (int)deg_to_raw(degree_0);
	int raw1 = (int)deg_to_raw(degree_1);

	*SERVOS &= 0;
	*SERVOS |= (raw1 << SERVO_1) | raw0;
}
