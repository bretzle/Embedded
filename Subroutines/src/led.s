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

.global num_to_LED_init
.global num_to_LED


# enable leds
num_to_LED_init:
    # enable gpio
    push {R1, R2, R3, LR}
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
    pop  {R1, R2, R3, PC}

# print a binary number to the leds.
# number stored in R0
num_to_LED:
	ldr  R1, =GPIOB_BASE
    ldr  R2, [R1, #GPIO_ODR]
    mov  R3, #1
    mov  R4, #0

1:
    lsrs R0, R3
    add  R4, R4, #1
	bcs  2f // carry out
	bne  1b
	str  r2, [r1,#GPIO_ODR]
	bx   LR

2:
	mov r5, #0
	add r5, r5, r4
	lsl r6, r3, r5
	orr r2, r2, r6
	b 1b
