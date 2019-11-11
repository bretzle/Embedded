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

	bl tim2_init

loop:

1:  // poll status register
	ldr R0, =ADC1_BASE
	ldr R1, [R0, #ADC_SR]
	ands R1, R1, #(1<<1)
	beq 1b

	ldr R1, [R0, #ADC_DR]
	#bl lcd_print_num // value in mV

	bl convert_to_c
	#bl lcd_print_num // value in C

	bl convert_to_f
	bl lcd_home
	bl pretty_print // value in F

	mov R1, #0

end:
	b loop

// R1 : input : binary time
pretty_print:
	push {R0-R4, LR}

	bl num_to_bcd

	ubfx R2, R0, #8, #4  // tens
	ubfx R3, R0, #4, #4  // ones
	ubfx R4, R0, #0, #4  // mantissa

	// convert to ascii
	add R2, R2, #0x30
	add R3, R3, #0x30
	add R4, R4, #0x30

	mov R1, R2
	bl lcd_write_data

	mov R1, R3
	bl lcd_write_data

	mov R1, '.'
	bl lcd_write_data

	mov R1, R4
	bl lcd_write_data

	pop  {R0-R4, PC}

// converts celsius register to farhenheit
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

// converts mV register to celcius
//
// R1 : input
// R1 : output
convert_to_c:
	push {R0, R2, LR}

	mov R0, R1

	mov R1, #3300
	mov R2, #4095
	mul R1, R1, R0
	udiv R1, R1, R2
	mov R0, #250
	mov R2, #750
	sub R1, R1, R2
	add R1, R1, R0

	pop  {R0, R2, PC}

.section .data

	// booleans
	buffer_mode:     .byte 0 // 0->dont write to buffer | 1->write to buffer
	temp_mode:       .byte 0 // 0->Celsius | 1->Fahrenheit
	continuous_mode: .byte 0 // 1-> write values to lcd when calculated

	// integers
	interval:        .byte 1 // [1-9]
	buffer_size:     .byte 1 // [1-100]
	buffer_pos:      .byte 0 // [1-buffer_size]

	.balign 4
	temperature_buffer:
		.space 100
