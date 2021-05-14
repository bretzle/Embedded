//! John Bretz
//! CE2820
//! main.c
//! Analog stick API impl

#include "system.h"
#include "analog.h"
#include <stdint.h>

static volatile int* cmd = (volatile int *) JOYSTICK_ADC_SEQUENCER_CSR_BASE;
static volatile int* values = (volatile int *) JOYSTICK_ADC_SAMPLE_STORE_CSR_BASE;

/// Maps a number from 0..4096 to -100..100
static int map(int n)
{
	return (int) ((float) n / 4096 * 200 + -100);
}

void analog_init(void)
{
	*cmd = 1;
}

void get_analog_data(int32_t storage[2])
{
	storage[0] = map(*(values+0) & 0xFFF);
	storage[1] = map(*(values+1) & 0xFFF);
}
