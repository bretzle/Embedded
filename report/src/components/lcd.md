# LCD Display

## Overview

The LCD component makes use of the LT24 Display. The display is 320x240 pixels and uses 16-bit color opposed to the traditional 24. The component makes use of Framebuffers in memory to handle pixel data.

## Memory Map

The component allocates 150 KibiBytes on the heap when the framebuffers are initialized. This data must be freed after use. 

## Theory of Operation

The LCD will be automatically initialized when the system powers up. The display makes use of two framebuffers. The display has direct memory access to the frontbuffer. The buffers can be swapped by calling `lcd_present`. The display also supports touch interaction ([See components/touch](./touch.md)).

## Hardware Connections

The display uses the entire 40 pin GPIO Bus. 

*More info can be found in the [LT24 Datasheet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiFgNTmhNHwAhURbc0KHZDBDokQFjAAegQIBRAD&url=https%3A%2F%2Fwww.terasic.com.tw%2Fcgi-bin%2Fpage%2Farchive_download.pl%3FLanguage%3DEnglish%26No%3D892%26FID%3D527f33a451f2c9a404934446366f5342&usg=AOvVaw01SB6SgxbhnAOCPr9bi4va)*

## Testing and Usage

```c
#include "lcd.h"

lcd_init(); // initialize the framebuffer

lcd_clear(); // clears the screen by setting every pixel to white

lcd_draw_rectangle(0, 0, WIDTH, HEIGHT, RED); // draws a red line from (0,0) to (WIDTH, HEIGHT) 

lcd_present(); // swaps the framebuffers and draws changes

lcd_free(); // Once done drawing free the framebuffers
```