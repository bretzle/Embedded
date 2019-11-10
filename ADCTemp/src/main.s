.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ ADC_CR2, 0x08
	.equ ADC_SR, 0x00
	.equ ADC_DR, 0x4C
	.equ AHB1ENR_OFFSET, 0x30
	.equ GPIOB_EN, 1<<1
	.equ APB2ENR_OFFSET, 0x44
	.equ ADC1_EN, 1<<8
	.equ ADC_SQR3, 0x34
	.equ RCC_BASE, 0x40023800
	.equ ADC1_BASE, 0x40012000

.global main

main:
	bl key_init
	bl lcd_init
	bl temp_init
	bl adc_init

	#bl tim2_init

loop:

	// start conversion
	ldr R0, =ADC1_BASE
	ldr R1, [R0, #ADC_CR2]
	orr R1, R1, #(1<<30)
	str R1, [R0, #ADC_CR2]

1:  // poll status register
	ldr R1, [R0, #ADC_SR]
	ands R1, R1, #(1<<1)
	beq 1b

	ldr R1, [R0, #ADC_DR]

	bl lcd_print_num

	mov R0, R1

	mov R1, #3300
	mov R2, #4095
	mul R1, R1, R0
	udiv R1, R1, R2
	mov R0, #250
	mov R2, #750
	sub R1, R1, R2
	add R1, R1, R0

	bl lcd_print_num

	bl convert_to_f
	bl lcd_print_num

	mov R1, #0

end:
	b loop


// converts celsius register to farienheight
// celcius must be in tenths of a degree
//
// R1 : input
// R1 : output
convert_to_f:
	push {R2, LR}

	mov R2, #9
	mul R1, R1, R2
	mov R2, #5
	udiv R1, R1, R2
	add R1, R1, #320

	pop  {R2, PC}
