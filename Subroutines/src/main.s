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

main:
    @bl LED_init

    @mov R0, #0b1111111111
    @bl num_to_LED

	@mov R1, #1
	@bl byte_to_ASCII

	mov R1, #1234
	bl num_to_bcd

end:
	b end

num_to_ASCII:
    bx LR
