# LEDs

## Overview

There are 10 LEDs that can be controlled on the board

## Memory Map

The component utilizes 10 bits, 1 for each LED.

When a bit is high the LED will turn on.

```
+-------+-----+-----+-------+-------+-------+
| LED 9 | ... | ... | LED 2 | LED 1 | LED 0 |
+-------+-----+-----+-------+-------+-------+
```

## Theory of Operation

Nothing needs to be initialized. Simply read the memory itself or use the api calls.

## Hardware Connections

The components is hardwired to the LEDs on the board

## Testing and Usage

```c
write_leds(0x3FF); // Turns on all leds
write_leds(0x001); // Turns off all leds except the first
```