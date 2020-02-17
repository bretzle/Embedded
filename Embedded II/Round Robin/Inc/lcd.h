/**
  ******************************************************************************
  * @file    lcd.h
  * @author  John Bretz
  * @version V1.0
  * @brief   Function prototypes for the LCD.
  ******************************************************************************
*/

#ifndef LCD_H
#define LCD_H

/// Initializes the LCD
void lcd_init(void);

/// Clears the LCD. Includes delay
void lcd_clear(void);

/// Moves the cursor back home. Includes delay
void lcd_home(void);

/// Moves the cursor to some location. Includes delay
/// @param row top row is 0, bottom row is 1
/// @param col column is 0 to 39. Only 0 to 15 are visible
void lcd_set_position(char row, char col);

/// Prints a string to the LCD. Does not word wrap. Includes delay.
/// @param string the string to print
void lcd_print_string(char string[]);

/// Prints an integer to the LCD. Does not wrap. Includes delay.
/// @param number the int to print
void lcd_print_num(int number);

/// Print a single ascii charcter to the LCD. Includes delay.
/// @param charcter an ascii char
void lcd_print_char(char character);

#endif