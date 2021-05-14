//! John Bretz
//! CE2820
//! pushbutton.h
//! pushbutton api impl

#ifndef PUSHBUTTON_H_
#define PUSHBUTTON_H_

#define BUTTON_1 1
#define BUTTON_2 2

/// Whether or not a button is pressed
///
/// Use `BUTTON_1` or `BUTTON_2`
int is_button_pressed(int button);

#endif /* PUSHBUTTON_H_ */
