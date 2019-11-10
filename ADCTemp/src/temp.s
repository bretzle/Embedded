.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE,    0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOBEN, 0x2

	.equ GPIOB_BASE,  0x40020400
	.equ GPIO_MODER,  0x00
	.equ GPIO_IDR,    0x10
	.equ GPIO_ODR,    0x14

.global temp_init
.global get_raw_temp

temp_init:
	push {R0-R1, LR}

	ldr R0, =RCC_BASE

	// enable gpiob
	ldr  R1, [R0, #RCC_AHB1ENR]
	orr  R1, R1, #RCC_GPIOBEN
	str  R1, [R0, #RCC_AHB1ENR]

	// enable pin
	ldr R0, =GPIOB_BASE
	ldr R1, [R0, #GPIO_MODER]
	orr R1, R1, #0b11 // analog
	str R1, [R0, #GPIO_MODER]

	pop  {R0-R1, PC}

@ R0 : Output : some number
get_raw_temp:
	push {R1, LR}

	ldr R0, =GPIOB_BASE
	ldr R1, [R0, #GPIO_IDR]
	ubfx R0, R1, #0, #1

	pop  {R1, PC}

