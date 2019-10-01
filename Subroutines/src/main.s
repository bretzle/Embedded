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
    bl LED_init

    mov R0, #1234
    bl num_to_LED

end:
	b end

num_to_ASCII:
    bx LR
