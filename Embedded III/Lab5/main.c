//! John Bretz
//! CE2820
//! main.c
//! Entrypoint
//!
//! Draws shapes to the LCD using DMA Framebuffers

#include <stdio.h>
#include "lcd.h"

int main()
{
  lcd_init();

  draw_rectangle(24, 32, WIDTH - 33, HEIGHT - 25, 0xFF00FF, true);
  draw_rectangle(24, 32, WIDTH - 33, HEIGHT - 25, WHITE, false);

  draw_line(0, 0, WIDTH-1, HEIGHT-1, RED);
  draw_line(0, HEIGHT-1, WIDTH-1, 0, RED);

  lcd_present();

  lcd_free();

  return 0;
}

