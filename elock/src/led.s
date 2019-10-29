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
	push {r0-r1,lr}

	ldr r0,=GPIOB_BASE
	ldr r1,[r0,GPIO_ODR]
	orr r1,r1,#(0b1<<5)
	str r1,[r0,GPIO_ODR]

	pop {r0-r1,pc}

# The subroutine turns off the right most led.
turn_off_edge_led:
	push {r0-r1,lr}

	ldr r0,=GPIOB_BASE
	ldr r1,[r0,GPIO_ODR]
	bic r1,r1,#(0b1<<5)
	str r1,[r0,GPIO_ODR]

	pop {r0-r1,pc}
