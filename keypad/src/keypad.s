# keypad.s
# John Bretz
# CE 2801
# Lab 5
# Description: keypad api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE, 0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOCEN, 0x4

	.equ GPIOC_BASE, 0x40020800

	.equ GPIO_MODER, 0x0
	.equ GPIO_IDR, 0x10
	.equ GPIO_ODR, 0x14
	.equ GPIO_PUPDR, 0xC

	.equ BSRR_OFFSET, 0x18

.global key_init

key_init:
	push {R1-R2, LR}

	ldr R1, =RCC_BASE

	@ enable gpio bus
	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, RCC_GPIOCEN
	str R2, [R1, #RCC_AHB1ENR]

	@ set pin 0-3 to input
	ldr R1, =GPIOC_BASE
	ldr R2, [R1, GPIO_MODER]
	orr R2, R2, #0x55
	bic R2, R2, #0xAA
	str R2, [R1, #GPIO_MODER]

	@ set pin 4-7 to output
	ldr R1, =GPIOC_BASE
	ldr R2, [R1, GPIO_PUPDR]
	orr R2, R2, 0x5500
	str R2, [R1, #GPIO_PUPDR]

	pop  {R1-R2, PC}
