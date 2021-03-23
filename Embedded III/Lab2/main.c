//! John Bretz
//! CE2820
//! main.c
//! Entrypoint
//!
//! When KEY1 is pressed the binary value from the Slider Switches should be displayed on Hex3-Hex0 7 Segment displays. (0-1023)
//! When KEY0 is pressed the 7segment display should be cleared and go blank.

#include <stdio.h>
#include <system.h>
#include "seven_seg.h"

#define KEY0 1
#define KEY1 2

int main()
{
  printf("Hello Lab 2!\n");

  int *button = (volatile int *)PUSHBUTTONS_BASE;
  int *switches = (volatile int *)SLIDER_SWITCHES_BASE;

  while (1)
  {
    // Handle button presses
    if ((*button & 0x3) == KEY1)
    {
      int val = *switches & 0x3FF;
      write_hex_display(val, 10);
    }
    else if ((*button & 0x3) == KEY0)
    {
      clear_hex_display();
    }
  }

  return 0;
}
