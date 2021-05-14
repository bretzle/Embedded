# LCD

## Overview

LCD controller and DMA driver for the LT24 LCD display.

## Memory Map & Register Usage
| Signal  | Description                     |
|---------|---------------------------------|
| lcd_on  | Turns display on/off            |
| reset_n | Resets the display              |
| csx     | Active low chip select          |
| data    | data bus                        |
| rdx     | read                            |
| wrx     | write                           |
| dcx     | data when '1', command when '0' |

## Theory

The LCD will be properly initialized automatically on boot. The rest of the signals are also managed automatically by the controller. Commands and Data are sent to the LCD throught the controller and the DMA component. 

Framebuffers are used to handle writing pixel data to the screen. So, framebuffers must be initialized prior to drawing to the screen.

The display itself uses 16-bit color (565). The software driver accepts 24-bit color (888) and will convert it to 16-bit.

## Hardware Connections
All signals are mapped to the appropiate **GPIO** pins

## Usage

```c
#include "lcd.h"

// Initialize the framebuffers in memory
lcd_init();

// Draw a 100x100 purple square
draw_rectangle(0, 0, 100, 100, 0xFF00FF);

// Render the framebuffer to the LCD
lcd_present();

// Free framebuffers when done
lcd_free();

```