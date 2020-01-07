#include "timing.h"
#include <string.h>
#include <stdio.h>

#define MODER 0
#define IDR 4
#define ODR 5
#define BSRR 6

#define SET 1
#define OUTPUT 0b01
#define RS_SET 1 << 8
#define RW_SET 1 << 9
#define E_SET  1 << 10
#define RS_CLR ~(RS_SET)
#define RW_CLR ~(RW_SET)
#define E_CLR ~(E_SET)

volatile int *rcc_ahb1enr = (int *) 0x40023830;
volatile int *GPIOA_BASE = (int *) 0x40020000;
volatile int *GPIOC_BASE = (int *) 0x40020800;

void lcd_cmd_d(int, int);

void lcd_init(void) {
	*rcc_ahb1enr |= (1 << 0);
	GPIOA_BASE[MODER] |= 0x555500;

	*rcc_ahb1enr |= (1 << 2);
	GPIOC_BASE[MODER] |= 0x150000;

	delay_ms(40);
	lcd_cmd_d(0x38, 37);
	lcd_cmd_d(0x38, 37);
	lcd_cmd_d(0x0F, 37);
	lcd_cmd_d(0x01, 1520);
	lcd_cmd_d(0x06, 37);
}

void lcd_cmd_d(int instruction, int delay) {
	GPIOC_BASE[ODR] &= RS_CLR;
	GPIOC_BASE[ODR] &= RW_CLR;
	GPIOC_BASE[ODR] |= E_SET;

	GPIOA_BASE[ODR] &= ~(0xFF << 4);
	GPIOA_BASE[ODR] |= ((instruction & 0xFF) << 4);

	GPIOC_BASE[ODR] &= E_CLR;

	delay_us(delay);
}

void lcd_data(int data) {
	GPIOC_BASE[BSRR] |= RS_SET;
	GPIOC_BASE[BSRR] |= (1 << (9+16));
	GPIOC_BASE[BSRR] |= E_SET;

	GPIOA_BASE[BSRR] |= (0xFF << (4+16));
	GPIOA_BASE[BSRR] |= ((data & 0xFF) << 4);

	GPIOC_BASE[BSRR] |= (1 << (10 + 16));

	delay_ms(2);
}


void lcd_clear(void) {
	lcd_cmd_d(0x01, 1520);
}

void lcd_home(void) {
	lcd_cmd_d(0x02, 1520);
}

void lcd_set_position(char row, char col) {
	int cmd = (1 << 7) + (col + (row * 0x40));
	lcd_cmd_d(cmd, 37);
}

void lcd_print_string(char string[]) {
	int str_len = strlen(string);
	for (int i=0; i<str_len; i++) {
		lcd_data(string[i]);
	}
}

void lcd_print_num(int number) {
	char num_str[32];
	sprintf(num_str, "%d", number);
	lcd_print_string(num_str);
}

void lcd_print_char(char character) {
	char str[32];
	sprintf(str, "%c", character);
	lcd_print_string(str);
}
