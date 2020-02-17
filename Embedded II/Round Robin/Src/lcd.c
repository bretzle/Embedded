/**
  ******************************************************************************
  * @file    lcd.c
  * @author  John Bretz
  * @version V1.1
  * @brief   Functions for LCD api.
  ******************************************************************************
*/

#include "register.h"
#include "timer.h"
#include <string.h>
#include <stdio.h>

#define RS_SET 1 << 8
#define RW_SET 1 << 9
#define E_SET  1 << 10
#define RS_CLR ~(RS_SET)
#define RW_CLR ~(RW_SET)
#define E_CLR ~(E_SET)

static int *const GPIOA = (int *) GPIOA_BASE;
static int *const GPIOC = (int *) GPIOC_BASE;

static TIM* tim4 = (TIM*) TIM4_BASE;

static int lcd_flag = 0;

/// Send a command to the LCD display with a delay
/// @param instruction the cmd to send to the LCD
/// @param delay the number of microseconds to delay
///              to allow the cmd to process
void lcd_cmd_d(int, int);

static void delay_ms(int);
static void delay_us(int);

void lcd_init(void) {
	init_tim4();
	enable_tim4_int(tim4);

	volatile int *const RCC = (int *) RCC_BASE;

	RCC[AHB1ENR] |= (GPIOAEN | GPIOCEN);

	GPIOA[MODER] |= 0x555500; // data pins
	GPIOC[MODER] |= 0x150000; // control pins

	delay_ms(40);
	lcd_cmd_d(0x38, 37);
	lcd_cmd_d(0x38, 37);
	lcd_cmd_d(0x0F, 37);
	lcd_cmd_d(0x01, 1520);
	lcd_cmd_d(0x06, 37);
}

void lcd_cmd_d(int instruction, int delay) {
	GPIOC[ODR] &= RS_CLR;
	GPIOC[ODR] &= RW_CLR;
	GPIOC[ODR] |= E_SET;

	// send instruction
	GPIOA[ODR] &= ~(0xFF << 4);
	GPIOA[ODR] |= ((instruction & 0xFF) << 4);

	GPIOC[ODR] &= E_CLR;

	delay_us(delay);
}

void lcd_data(int data) {
	GPIOC[BSRR] |= RS_SET;
	GPIOC[BSRR] |= (1 << (9+16));
	GPIOC[BSRR] |= E_SET;

	// send data
	GPIOA[BSRR] |= (0xFF << (4+16));
	GPIOA[BSRR] |= ((data & 0xFF) << 4);

	GPIOC[BSRR] |= (1 << (10 + 16));

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
	char str[2];
	sprintf(str, "%c", character);
	lcd_print_string(str);
}

void delay_ms(int num) {
	tim4->PSC = 16000 - 1;
	tim4->ARR = num;
	start(tim4);

	while (!lcd_flag);
	lcd_flag = 0;
}

void delay_us(int num) {
	tim4->PSC = 16 - 1;
	tim4->ARR = num;
	start(tim4);

	while (!lcd_flag);
	lcd_flag = 0;
}

void TIM4_IRQHandler(void) {
	tim4->SR &= ~1;
	stop(tim4);
	lcd_flag = 1;
}