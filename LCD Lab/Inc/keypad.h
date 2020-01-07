
#ifndef KEYPAD_H
#define KEYPAD_H

/// Initializes the keypad
void keypad_init(void);

/// Returns a keycode of a key press.
/// Function will not return untill a key is pressed.
/// @return returns 0 - 15
int keypad_getkey(void);

/// Returns a keycode of a key press.
/// Similar to keypad_getkey() but does not block.
/// @return returns 0 - 15 but if no key was pressed -1
int keypad_getkey_noblock(void);

/// Returns an ascii char of the key press
/// Function will not return untill a key is pressed.
/// @return the ascii char
char keypad_getchar(void);

#endif
