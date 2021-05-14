//! John Bretz
//! CE2820
//! main.c
//! Entrypoint
//!
//! Fills the LCD with random colors

#include "lcd.h"
#include "rand.h"

static Rand RANDOM = {0xDEADBEEF};

int main()
{
  lcd_init();

  while (1)
  {
    lcd_fill((short)gen_rand(&RANDOM));
  }

  return 0;
}
