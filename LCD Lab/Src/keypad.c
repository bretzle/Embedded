
#include "keypad.h"
#include "register.h"
#include "timing.h"

#define KEYPAD_COL1 0
#define KEYPAD_COL2 1
#define KEYPAD_COL3 2
#define KEYPAD_COL4 3
#define KEYPAD_ROW1 4
#define KEYPAD_ROW2 5
#define KEYPAD_ROW3 6
#define KEYPAD_ROW4 7

#define ROW_COUNT 4
#define COL_COUNT 4

//static int scan();

static int *const GPIOC = (int *)GPIOC_BASE;

void keypad_init(void) {
  volatile int *const RCC = (int *)RCC_BASE;

  RCC[AHB1ENR] |= GPIOCEN;

  GPIOC[MODER] &= ~(0xFF);
  GPIOC[MODER] |= 0x55;

  GPIOC[PUPDR] &= ~(0xFF00);
  GPIOC[PUPDR] |= 0x5500;
}

int keypad_getkey(void) {
  int key_value = 0;
	while (key_value == 0) {
		key_value = keypad_getkey_noblock();
		int row_logic = 0;
		/* repeat determining if the key has been released. */
		while (!(row_logic == 0b1111)) {
			row_logic = (GPIOC[IDR] >> 4) & ~0xFFF0;
		}
	}
	return key_value;
}

int keypad_getkey_noblock(void) {
  int four_set_bits = 0b1111;
	int clear_bit = 1;
	int pressed = 0;
	int key_value = 0;
	/* The algorithm for determining which key is being pressed. */
	for (int col = 1; col <= 4 && pressed == 0; col++) {
		int col_logic = four_set_bits & ~(clear_bit << (col - 1));
		GPIOC[BSRR] |= 0b1111 << 16; // clear previous odr logic.
		GPIOC[BSRR] |= col_logic; // set new logic.
		for (int row = 1; row <= 4 && pressed == 0; row++) {
			int row_logic = (GPIOC[IDR] >> 4) & ~0xFFF0; // get the row logic for comparing.
			/* determine if the current row is being pressed. */
			if (row_logic == (four_set_bits & ~(clear_bit << (row - 1)))) {
				pressed = 1;
				key_value = (row - 1) * 4 + col;
			}
		}
	}
	return key_value;
}

char keypad_getchar(void)
{
  static const char keys[] = {
      '1', '2', '3', 'A',
      '4', '5', '6', 'B',
      '7', '8', '9', 'C',
      '*', '0', '#', 'D'};

  return keys[keypad_getkey() - 1];
}
