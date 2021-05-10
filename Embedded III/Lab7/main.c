//! John Bretz
//! CE2820
//! main.c
//! entrypoint
//!
//! Emulates an etch-a-sketch using the joystick
//! Button 1 terminates the program
//! Button 2 clears the screen and recenters the cursor

#include "system.h"
#include "analog.h"
#include "lcd.h"
#include "seven_seg.h"

volatile int *BUTTONS = (volatile int *)PUSHBUTTONS_BASE;

/// Sets the min and max value of a number
static void clamp(int *val, int min, int max)
{
  if (*val > max)
  {
    *val = max;
  }
  else if (*val < min)
  {
    *val = min;
  }
}

int main()
{
  analog_init();
  lcd_init();

  AnalogData data;
  int x = WIDTH / 2;
  int y = HEIGHT / 2;

  while (*BUTTONS != 1)
  {
    if (*BUTTONS == 2)
    {
      lcd_clear();
      x = WIDTH / 2;
      y = HEIGHT / 2;
      continue;
    }

    data = get_analog_data();

    // update x position
    if (data.x > ANALOG_THRESHOLD)
    {
      x -= 1;
      clamp(&x, 0, WIDTH - 1);
    }
    else if (data.x < -ANALOG_THRESHOLD)
    {
      x += 1;
      clamp(&x, 0, WIDTH - 1);
    }

    // update y position
    if (data.y > ANALOG_THRESHOLD)
    {
      y -= 1;
      clamp(&y, 0, HEIGHT - 1);
    }
    else if (data.y < -ANALOG_THRESHOLD)
    {
      y += 1;
      clamp(&y, 0, HEIGHT - 1);
    }

    // draw to screen
    set_pixel(x, y, RED);
    lcd_present();

    // display coords
    int seg = ((x + 1) * 1000) + (y + 1);
    write_hex_display(seg, 10);
  }

  lcd_free();

  return 0;
}
