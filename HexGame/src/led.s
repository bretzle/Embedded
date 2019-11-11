# timer.s
# John Bretz
# CE 2801
# Lab 5
# Description: timer/counter api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE, 0x40023800
	.equ GPIOB_BASE, 0x40020400
	.equ GPIOBEN, 0x2

	.equ GPIO_AHB1ENR, 0x30
	.equ GPIO_MODER, 0x0

	.equ GPIO_ODR, 0x14

.global led_init
.global turn_on_edge_led
.global turn_off_edge_led
.global num_to_LED

led_init:
	push {R1-R3, LR}

	ldr R1, =RCC_BASE

	ldr R2, [R1, #GPIO_AHB1ENR]
	orr R2, R2, #GPIOBEN
	str R2, [R1, #GPIO_AHB1ENR]

	# set pins to output
	ldr R1, =GPIOB_BASE
	ldr R2, [R1, #GPIO_MODER]

	movw R3, #0x5400
	movt R3, #0x5515
	orr R2, R2, R3

	movw R3, #0xA800
	movt R3, #0xAA2A
	bic R2, R2, R3

	str R2, [R1, #GPIO_MODER]

	pop {R1-R3, PC}

# The subroutine turns on the right most led.
turn_on_edge_led:
	push {R0-R1, LR}

	ldr R0, =GPIOB_BASE
	ldr R1, [R0, GPIO_ODR]
	orr R1, R1, #(0b1<<5)
	str R1, [R0, GPIO_ODR]

	pop {R0-R1, PC}

# The subroutine turns off the right most led.
turn_off_edge_led:
	push {R0-R1, LR}

	ldr R0, =GPIOB_BASE
	ldr R1, [R0, GPIO_ODR]
	bic R1, R1, #(0b1<<5)
	str R1, [R0, GPIO_ODR]

	pop {R0-R1, PC}

# prints a 10 bit number to the LEDs.
#
# input : R1
# temp  : R2  location to gpio
# temp  : R3  location to odr
# temp  : R4  mask to disable all LEDs
# temp  : R5  mask of LEDs to enable
num_to_LED:
	push {R2-R5, LR}

	ldr  R2, =GPIOB_BASE
	ldr  R3, [R2, #GPIO_ODR]

	mov  R4, 0xF7E0
	bic  R3, R3, R4           @ disable all LEDs

	lsl R4, R1, #22
	bic R4, R4, #0x0FFFFFFF   @ create mask for the first 4 LEDs

	bic R5, R1, #0xFFFFFFC0
	lsl R5, R5, #21			  @ create mask for the bottom 6 LEDs

	orr R3, R3, R4			  @ merge masks
	orr R3, R3, R5			  @ merge masks
	lsr R3, R3, #16		      @ shift mask to correct location
	str R3, [R2, #GPIO_ODR]   @ write to odr

	pop {R2-R5, PC}
