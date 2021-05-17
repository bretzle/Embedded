# Seven Segment

## Overview

There are six seven-segment displays on the the DE10-Lite. Each display has its own decoder in hardware. These decoders support all hexadecimal characters.

## Memory Map

Each decoder is 5 bits in memory where the first 4 are the digit to display
and an enable bit. When the enable bit is set to 0 nothing will be displayed.

```
Ex.
  +---+---+---+---+---+
  | 1 | 0 | 0 | 1 | 1 |   Would display 9 on the display
  +---+---+---+---+---+
   ^----Data----^   ^ Enable bit
  +---+---+---+---+---+
  | 1 | 0 | 0 | 1 | 0 |   No display
  +---+---+---+---+---+
```

## Theory of Operation

Nothing needs to be initialized. One can simply call the api's functions to write to each display.

## Hardware Connections

The decoders are built into the system itself and are hardwired to the displays.

## Testing and Usage

```c
#include "seven_seg.h"

write_hex_display(123456, 10); // writes "123456"

write_hex_display(0xDEADBEEF, 16); // writes "DEADBEEF"
```