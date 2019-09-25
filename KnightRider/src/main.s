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

	# turn on gpiob

	ldr r1, =RCC_BASE

	ldr r2, [r1, #RCC_AHB1ENR]
	orr r2, r2, #RCC_GPIOBEN
	str r2, [r1, #RCC_AHB1ENR]


	# enable pb5-pb10m pb12-pb15 to output

	ldr r1, =GPIOB_BASE
	ldr r2, [r1, #GPIO_MODER]

	movw r3, #0x5400
	movt r3, #0x5515
	orr r2, r2, r3

	movw r3, #0xA800
	movt r3, #0xAA2A
	bic r2, r2, r3

	str r2, [r1, #GPIO_MODER]


begin:

	# run forward
	movw R0, #0x4000
	bl toggle_light
	bl delay

	movw R0, #0x2000
	bl toggle_light
	bl delay

	movw R0, #0x1000
	bl toggle_light
	bl delay

	movw R0, #0x800
	bl toggle_light
	bl delay

	movw R0, #0x400
	bl toggle_light
	bl delay

	movw R0, #0x200
	bl toggle_light
	bl delay

	movw R0, #0x100
	bl toggle_light
	bl delay

	movw R0, #0x80
	bl toggle_light
	bl delay

	movw R0, #0x40
	bl toggle_light
	bl delay

	movw R0, #0x20
	bl toggle_light
	bl delay

	# run back

	movw R0, #0x40
	bl toggle_light
	bl delay

	movw R0, #0x80
	bl toggle_light
	bl delay

	movw R0, #0x100
	bl toggle_light
	bl delay

	movw R0, #0x200
	bl toggle_light
	bl delay

	movw R0, #0x400
	bl toggle_light
	bl delay

	movw R0, #0x800
	bl toggle_light
	bl delay

	movw R0, #0x1000
	bl toggle_light
	bl delay

	movw R0, #0x2000
	bl toggle_light
	bl delay

	movw R0, #0x4000
	bl toggle_light
	bl delay

	# goto turn all on
	b begin

delay:
	ldr r12, =0x00200000

1:
	subs r12, r12, #1
	bne 1b
	bx LR

toggle_light:
	# light mask in R0
	ldr R2, [R1, #GPIO_ODR]
	movw R3, #0xF7E0
	bic R2, R2, R3 // turn all lights off
	orr R2, R2, R0      // enable light in R0
	str R2, [R1, #GPIO_ODR] // write
	bx LR
