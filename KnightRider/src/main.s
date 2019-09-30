# main.s
# John Bretz
# CE 2801
# Lab 2
# Description: Knight Rider Lights

# lights = PB5-PB15 skip PB11

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE,    0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOBEN, 0x2

	.equ GPIOB_BASE,  0x40020400
	.equ GPIO_MODER,  0x00
	.equ GPIO_ODR,    0x14

.global main

main:

	# turn on GPIOB

	ldr R1, =RCC_BASE

	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, #RCC_GPIOBEN
	str R2, [R1, #RCC_AHB1ENR]


	# enable pb5-pb10m pb12-pb15 to output

	ldr R1, =GPIOB_BASE
	ldr R2, [R1, #GPIO_MODER]

	movw R3, #0x5400
	movt R3, #0x5515
	orr  R2, R2, R3

	movw R3, #0xA800
	movt R3, #0xAA2A
	bic  R2, R2, R3

	str  R2, [R1, #GPIO_MODER]


	# load constant 1 and default shift into registers
	movw R0, #15
	movw R4, #1

# toggles lights going forward
forward_loop:
	lsl  R5, R4, R0
	bl   toggle_light
	bl   delay
	cmp  R0, #12   // skip pin 11
	beq  2f
	cmp  R0, #5
	bgt  1f

	add  R0, R0, #1 // dont toggle the last light twice in a row
	b    backward_loop

# decrement shift
1:
	sub  R0, R0, #1
	b    forward_loop

# decrement shift by two
2:
	sub  R0, R0, #2
	b    forward_loop

# toggles lights going backward
backward_loop:
	lsl  R5, R4, R0
	bl   toggle_light
	bl   delay
	cmp  R0, #10
	beq  2f         // skip pin 11
	cmp  R0, #15
	blt  1f

	sub  R0, R0, #1 // dont toggle the first light twice in a row
	b    forward_loop

# incremnt shift
1:
	add  R0, R0, #1
	b    backward_loop

# increment shift by two
2:
	add  R0, R0, #2
	b    backward_loop


# Busy loop
delay:
	ldr  R12, =0x00040000

1:
	subs R12, R12, #1
	bne  1b
	bx   LR

# will toggle a light on based on the mask stored in R5
toggle_light:
	ldr  R2, [R1, #GPIO_ODR] // read current value
	movw R3, #0xF7E0        // load clear mask
	bic  R2, R2, R3          // turn all lights off
	orr  R2, R2, R5          // enable light
	str  R2, [R1, #GPIO_ODR] // writeback
	bx   LR
