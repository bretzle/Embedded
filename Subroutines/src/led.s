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

.global LED_init
.global num_to_LED


# enable leds
LED_init:
    # enable gpio
    push {R1-R3, LR}
    ldr  R1, =RCC_BASE

	ldr  R2, [R1, #RCC_AHB1ENR]
	orr  R2, R2, #RCC_GPIOBEN
	str  R2, [R1, #RCC_AHB1ENR]


	# enable led pins
	ldr  R1, =GPIOB_BASE
	ldr  R2, [R1, #GPIO_MODER]

	movw R3, #0x5400
	movt R3, #0x5515
	orr  R2, R2, R3

	movw R3, #0xA800
	movt R3, #0xAA2A
	bic  R2, R2, R3

	str  R2, [R1, #GPIO_MODER]
    pop  {R1-R3, PC}

# print a binary number to the leds.
@ input : R1
num_to_LED:
	push {R2-R5, LR}

	ldr  R2, =GPIOB_BASE
    ldr  R3, [R2, #GPIO_ODR]
    mov  R4, 0xF7E0
    bic  R3, R3, R4

    lsl R4, R1, #22
    bic R4, R4, #0x0FFFFFFF // first 4

    bic R5, R1, #0xFFFFFFC0 // clear everything but the last 6 bits
    lsl R5, R5, #21

    orr R3, R3, R4
    orr R3, R3, R5
	lsr R3, R3, #16
    str R3, [R2, #GPIO_ODR]

	pop {R2-R5, PC}
