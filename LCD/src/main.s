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
	mov R2, #2000
	bl delay_ms
	bl lcd_clear

	@ print an invalid number
	mov R1, #0xFFFF
	bl lcd_print_num

	mov R2, #2000
	bl delay_ms
	bl lcd_clear

	@ print a string
	ldr R1, =msg
	bl lcd_print_string

	mov R2, #2000
	bl delay_ms

	bl lcd_home

	mov R2, #2000
	bl delay_ms
	bl lcd_clear

	mov R0, #1
	mov R1, #5

	bl lcd_set_position

	mov R2, #2000
	bl delay_ms

	bl lcd_home

	b start

.data
	msg: .asciz "Im a very long string"
