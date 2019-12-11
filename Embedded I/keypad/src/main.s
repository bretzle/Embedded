# main.s
# John Bretz
# CE 2801
# Lab 5
# Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

@ R2 : main : characters left on row
main:
	bl key_init
	bl lcd_init

clean:
	bl key_get_char

	// clear after getting key incase their is data already on LCD
	bl lcd_clear
	bl lcd_home
	mov R1, R0
	bl lcd_write_data

	mov R2, #15

1:
	bl key_get_char
	mov R1, R0
	bl lcd_write_data

	subs R2, R2, #1
	bne 1b

	// move to second line
	mov R0, #1
	mov R1, #0
	bl lcd_set_position

	mov R2, #16

1:
	bl key_get_char
	mov R1, R0
	bl lcd_write_data

	subs R2, R2, #1
	bne 1b

	b clean
