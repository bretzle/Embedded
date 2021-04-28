//! John Bretz
//! CE2820
//! main.c
//! entrypoint
//!
//! Draws red squares where the user is pressing.
//! Button 1 terminates the program
//! Button 2 clears the screen

#include <unistd.h>
#include "system.h"
#include "lcd.h"

volatile int *BUTTONS = (volatile int *)PUSHBUTTONS_BASE;

int main()
{
    lcd_init();
    touch_init();

    int x = 0;
    int y = 0;

    while (*BUTTONS != 1)
    {
        touch_get(&x, &y);

        // draw to both buffers
        draw_rectangle(x, y, x + 3, y + 3, RED, true);
        lcd_present();
        draw_rectangle(x, y, x + 3, y + 3, RED, true);

        if (*BUTTONS == 2)
        {
            lcd_clear();
        }
    }

    // cleanup
    lcd_clear();
    lcd_free();

    return 0;
}
