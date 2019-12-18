#include "timing.h"

#define MODER 0
#define IDR 4
#define ODR 5
#define BSRR 6

#define SET 1
#define OUTPUT 0b01
#define RS_SET 1 << 8
#define RS_CLR 1 << (8 + 16)
#define RW_SET 1 << 9
#define RW_CLR 1 << (9 + 16)
#define E_SET  1 << 10
#define E_CLR  1 << (10 + 16)

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
	GPIOC_BASE[ODR] &= ~RS_SET;
	GPIOC_BASE[ODR] &= ~RW_SET;
	GPIOC_BASE[ODR] |=   E_SET;

	GPIOA_BASE[ODR] &= ~(0xFF << 4);
	GPIOA_BASE[ODR] |= ((instruction & 0xFF) << 4);

	GPIOC_BASE[ODR] &= ~E_SET;

	delay_us(delay);
}

void lcd_data(int data) {
	GPIOC_BASE[ODR] |=  RS_SET;
	GPIOC_BASE[ODR] &= ~RW_SET;
	GPIOC_BASE[ODR] |=   E_SET;

	GPIOA_BASE[ODR] &= ~(0xFF << 4);
	GPIOA_BASE[ODR] |= ((data & 0xFF) << 4);

	GPIOC_BASE[ODR] &= ~E_CLR;

	delay_us(37);
}


void lcd_clear(void) {
	lcd_cmd_d(0x01, 1520);
}

void lcd_home(void) {
	lcd_cmd_d(0x02, 1520);
}

void lcd_set_position(char row, char col) {

}

void lcd_print_string(char *string[]) {

}

void lcd_print_num(int number) {

}
