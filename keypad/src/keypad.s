# keypad.s
# John Bretz
# CE 2801
# Lab 5
# Description: keypad api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE,

.global key_init

key_init:
	push {LR}



	pop  {PC}
