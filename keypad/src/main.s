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

@ R3 : main : cursor position
main:
	bl key_init
	bl lcd_init

	mov R3, #0

	bl key_get_char
	bl lcd_print_num

end:
	b end
