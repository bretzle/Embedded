# main.s
# John Bretz
# CE 2801
# Lab 3
# Description: Subroutines

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

@ convert 1234 to bcd
@ convert each column to ascii
@ print each ascii code to led with 500ms delay

main:
    bl LED_init
	mov R1, #1234

	bl num_to_bcd

end:
	b end

num_to_ASCII:
    bx LR
