//! John Bretz
//! CE2820
//! lcd.h
//! Api the LT24 Touch subsystem

#ifndef TOUCH_H_
#define TOUCH_H_

#include <stdint.h>

/// Initializes touch capabilities of the LCD.
/// Must have called `lcd_init()` before
void touch_init(void);

/// Gets the coordinate of the last touch on the LCD
///
/// @param storage: pointer to store [x, y]
void get_touch_data(int32_t storage[2]);

#endif /* TOUCH_H_ */
