
#include "timing.h"

static void write_instruction(char inst);
static void write_data(char data);

void lcd_clear(void);

#define RCC_AHB1ENR (volatile int *) 0x40023830

#define GPIOA_MODER (volatile int *) 0x40020000
#define GPIOC_MODER (volatile int *) 0x40020800

#define GPIOA_ODR (volatile int *) 0x40020014
#define GPIOC_ODR (volatile int *) 0x40020814

#define GPIOAEN 0x1
#define GPIOCEN 0x4

#define E_SET  0x400
#define RW_SET 0x200
#define RS_SET 0x100

void lcd_init(void) {
	// enable gpio bus
	*RCC_AHB1ENR |= GPIOAEN;
	*RCC_AHB1ENR |= GPIOCEN;

	// set pins to outputs
	*GPIOA_MODER |= 0x555500;
	*GPIOC_MODER |= 0x150000;

	delay_ms(100);

	// write function (0x38)
	write_instruction(0x38);
	delay_ms(37);

	// write function (0x38)
	write_instruction(0x38);
	delay_ms(37);

	// turn display on
	write_instruction(0x0F);
	delay_ms(37);

	// clear display
	write_instruction(0x01);
	delay_ms(1520);

	// write function (0x06)
	write_instruction(0x06);
	delay_ms(37);
}

static void write_instruction(char inst) {

	// set RS=0, RW=0, E=1
	*GPIOC_ODR &= ~RS_SET;
	*GPIOC_ODR &= ~RW_SET;
	*GPIOC_ODR |= E_SET;

	// send instruction
	*GPIOA_ODR |= (inst << 4);

	// set E=0
	*GPIOC_ODR &= ~E_SET;
}

static void write_data(char data) {
	*GPIOC_ODR &= ~RS_SET;
	*GPIOC_ODR |= RW_SET;
	*GPIOC_ODR |= E_SET;

	*GPIOA_ODR |= (data << 4);

	*GPIOC_ODR &= ~E_SET;

	delay_us(37);
}

void lcd_clear(void) {
	write_instruction(0x01);
	delay_ms(1520);
}

void lcd_home(void) {
	write_instruction(0x2);
	delay_us(1520);
}

void lcd_set_position(int row, int col) {

}

void lcd_print_string(char *string[]) {

}

void lcd_print_num(int number) {
	write_data('a');
}
