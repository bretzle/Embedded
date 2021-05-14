/*
 * seven_seg.h
 *
 *  Created on: Mar 9, 2021
 *      Author: bretzj
 */

#ifndef SEVEN_SEG_H_
#define SEVEN_SEG_H_

/// Writes a number to the Seven Segment Display. 
/// 
/// @param int num: The number to write
/// @return number of digits written. -1 on error
int write_hex_display(int num);

/// Clears the Seven Segment Display.
void clear_hex_display(void);

/// Writes a digit to one of the cells of the Display.
///
/// @param char: the ascii representation of the digit. Valid for '0'-'9'
/// @param int: the cell to write to. Valid for 0-5
void write_hex(char, int);

#endif /* SEVEN_SEG_H_ */
