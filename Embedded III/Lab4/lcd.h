//! John Bretz
//! CE2820
//! lcd.h
//! Api the LT25 LCD display

#ifndef LCD_H_
#define LCD_H_

#define LCD_WIDTH  320
#define LCD_HEIGHT  240

/// Some basic colors

#define WHITE 0xFFFF
#define BLACK 0x0000
#define RED   0xF800
#define GREEN 0x07E0
#define BLUE  0x001F

/// LCD methods

/// Initializes the display
void lcd_init(void);

/// Sets every pixel on the display to a color
///
/// @param color: the color
void lcd_fill(short color);

/// Sets the color of a pixel
///
/// (0, 0) is the top left corner of the screen
///
/// @param x: the x coordinate
/// @param y: the y coordinate
/// @param color: the color
void lcd_set_pixel(unsigned int x, unsigned int y, short color);

/// Formats the components of an RGB triplet to the 16-bit color space
///
/// @param r: red, should not exceed 0x1F (31)
/// @param g: green, should not exceed 0x3F (63)
/// @param b: blue, should not exceed 0x1F (31)
///
/// @return the 16-bit color
short color(unsigned int r, unsigned int g, unsigned int b);


#endif /* LCD_H_ */
