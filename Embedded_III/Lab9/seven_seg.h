//! John Bretz
//! CE2820-
//! seven_seg.h
//! API for Seven Segment Display
//!
//! Utilizes custom decoders in hardware to drive the Seven Segment Display
//! 
//! Each decoder is 5 bits in memory where the first 4 are the digit to display
//! and an enable bit. When the enable bit is set to 0 nothing will be displayed.
//!
//! Ex.
//!   +---+---+---+---+---+
//!   | 1 | 0 | 0 | 1 | 1 |   Would display 9 on the display
//!   +---+---+---+---+---+
//!    ^----Data----^   ^ Enable bit
//!   +---+---+---+---+---+
//!   | 1 | 0 | 0 | 1 | 0 |   No display
//!   +---+---+---+---+---+

#ifndef SEVEN_SEG_H_
#define SEVEN_SEG_H_

/// Writes a number to the Seven Segment Display.
///
/// Displays numbers in base 10 or base 16
///
/// Safety note:
///		if the number does not fit (> 6 digits) memory issues could arise
///     as sprintf() is used internally 
///
/// Ex.
///		write_hex_display(10, 10)  will display `10`
///		write_hex_display(10, 16)  will display `A`
///
/// @param int num: The number to write
/// @param int base: The base of the num. Valid for `10` and `16`
/// @return number of digits written. -1 on error
int write_hex_display(int num, int base);

/// Clears the Seven Segment Display.
void clear_hex_display(void);

/// Writes a digit to one of the cells of the Display.
///
/// @param char: the 4-bit number to display
/// @param int: the cell to write to. Valid for 0-5
void write_hex(char, int);

/// Clears one of the cells of the Display
///
/// @param int: The cell to clear. Valid for 0-5
void clear_hex(int block);

#endif /* SEVEN_SEG_H_ */
