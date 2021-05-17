# LCD Touch

## Overview

The LT24 LCD display is also a touch screen.

## Memory Map

This component has a control register and a data register. Interacting with both of these should be done through the provided API.

## Theory of Operation

The touch subsystem of the LCD utilizes an ADC as well as an SPI bus to communicate with that ADC.

The LCD must be initialized via `touch_init()` prior to reading touch data.

## Hardware Connections

This subsystem uses the same pins as the LCD display. See LCD Display documentation for more [info](./lcd.md)

## Testing and Usage

```c
#include "touch.h"
#include "lcd.h"

lcd_init();
touch_init();

int32_t data[2];

// Make any pixel red that is touched
while (1)
{
	get_touch_data(data);
	set_pixel(data[0], data[1], RED)
}
```