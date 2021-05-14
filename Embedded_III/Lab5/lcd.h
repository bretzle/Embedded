//! John Bretz
//! CE2820
//! lcd.h
//! Api the LT24 LCD display

#ifndef LCD_H_
#define LCD_H_

#include <stdbool.h>

/// Display height
#define HEIGHT 240

/// Display width
#define WIDTH  320

/// Some basic colors
#define WHITE 0xFFFFFF
#define BLACK 0x000000
#define RED   0xFF0000
#define GREEN 0x00FF00
#define BLUE  0x0000FF

/// Initializes the display
///
/// Safety:
/// Allocates memory for the frame buffer that must be freed
void lcd_init(void);

/// Sets every pixel on the display to a color
///
/// @param color: the color
void lcd_fill(int color);

/// Sets the color of a pixel
///
/// (0, 0) is the top left corner of the screen
///
/// @param x: the x coordinate
/// @param y: the y coordinate
/// @param color: the color
void set_pixel(unsigned int x, unsigned int y, int color);

/// Draws a line to the screen
///
/// @param x0: x top left point
/// @param y0: y top left point
/// @param x1: x bottom right point
/// @param y1: y bottom right point
/// @param color: the color
/// @param fill: fill the rectangle
void draw_rectangle(int x0, int y0, int x1, int y1, int color, bool fill);

/// Draws a line to the screen
///
/// @param x0: x start point
/// @param y0: y start point
/// @param x1: x end point
/// @param y1: y end point
/// @param color: the color
void draw_line(int x0, int y0, int x1, int y1, int color);

/// Presents the changes to the back buffer to the screen
void lcd_present(void);

/// Frees the memory that the LCD's framebuffer was using
void lcd_free(void);

#endif /* LCD_H_ */
