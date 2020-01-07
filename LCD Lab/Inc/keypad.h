
#ifndef KEYPAD_H
#define KEYPAD_H

void keypad_init(void);

int keypad_getkey(void);

int keypad_getkey_noblock(void);

char keypad_getchar(void);

#endif
