@ main.s
@ John Bretz
@ CE 2801
@ Lab 4
@ Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

#Fill in addresses
	.equ RCC_BASE, 0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOAEN, 0x1
	.equ RCC_GPIOCEN, 0x4

	.equ GPIOA_BASE, 0x40020000
	.equ GPIOC_BASE, 0x40020800
	.equ GPIO_MODER, 0x0
	.equ GPIO_ODR, 0x14
	.equ BSRR_OFFSET, 0x18

#What pin is each of these?
	.equ RS, 0x8
	.equ RW, 0x9
	.equ E,  0xA

#Commands for BSRR
	.equ E_SET,  0x400
	.equ RW_SET, 0x200
	.equ RS_SET, 0x100

.global main

main:
	bl LcdInit

	mov R1, #8
	bl lcd_print_num
end:
	b end
