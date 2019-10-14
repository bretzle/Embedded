@ main.s
@ John Bretz
@ CE 2801
@ Lab 4
@ Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

main:
	bl LcdInit

start:
	@ print valid number
	mov R1, #1234
	bl lcd_print_num

	@ wait a second
	mov R2, #1000
	bl delay_ms
	bl lcd_clear

	@ print an invalid number
	mov R1, #0xFFFF
	bl lcd_print_num

	mov R2, #1000
	bl delay_ms
	bl lcd_clear

	@ print a string
	mov R1, string
	bl lcd_print_string

	mov R2, #1000
	bl delay_ms
	bl lcd_clear

	b start

.section .data
	string: .asciz "Im a string"
