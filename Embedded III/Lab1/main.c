//! John Bretz
//! CE2820-
//! main.c
//! Entrypoint
//!
//! When KEY1 is press the binary value from the Slider Switches should be displayed on Hex3-Hex0 7 Segment displays. (0-1023)
//! When KEY0 is pressed the 7segment display should be cleared and go blank.

#include <stdio.h>
#include <system.h>
#include "seven_seg.h"


#define KEY0 1
#define KEY1 2

int main()
{
  printf("Hello World!\n");

  int *button = (int *) PUSHBUTTONS_BASE;
  int *switches = (int *) SLIDER_SWITCHES_BASE;
  char display = 0; // whether or not to display on seven_seg

  while (1)
  {
    // Handle button presses
    if ((*button & 0x3) == KEY1)
    {
      display = 1; // enable display
    }
    else if ((*button & 0x3) == KEY0)
    {
      display = 0; // disable display
      clear_hex_display();
    }

    // display
    if (display)
    {
      int val = *switches & 0x3FF;
      write_hex_display(val);
    }
  }

  return 0;
}
