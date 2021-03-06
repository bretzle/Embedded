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
.global convert_to_temp
.global pretty_print

main:
	bl key_init
	bl lcd_init
	bl temp_init
	bl adc_init
	bl tim2_init

loop:
	bl key_get_char

	cmp R0, 'D'
	beq toggle_temp_unit

	cmp R0, '#'
	beq set_interval

	cmp R0, 'B'
	beq set_buffer_size

	cmp R0, '*'
	beq toggle_buffer_mode

	b loop

toggle_buffer_mode:
	bl disable_interrupt
	bl lcd_clear
	ldr R1, =buffer_mode_on_msg
	bl lcd_print_string

	mov R0, #1
	mov R1, #0
	bl lcd_set_position

	ldr R1, =buffer_mode_flush_msg
	bl lcd_print_string

buffer_loop:

	bl key_get_char
	cmp R0, 'A'
	bne buffer_loop
	beq drain_buffer


drain_buffer:
	ldr R4, =buffer_size
	ldrb R5, [R4] // offset

1:
	ldr R1, [R4, R5]
	bl convert_to_temp
	bl lcd_home
	bl pretty_print

	mov R1, #500
	bl delay_ms

	subs R5, R5, #1
	bne 1b

	bl lcd_clear
	#bl enable_interrupt

	b loop

toggle_temp_unit:
	ldr R0, =temp_mode
	ldrb R1, [R0]

	cmp R1, #0
	beq 1f
	bne 2f

1:
	mov R2, #1
	b write

2:
	mov R2, #0

write:
	strb R2, [R0]
	b loop

set_interval:
	bl disable_interrupt
	bl lcd_clear
	ldr R1, =set_interval_msg1
	bl lcd_print_string

	mov R0, #1
	mov R1, #0
	bl lcd_set_position

	ldr R1, =set_interval_msg2
	bl lcd_print_string


	bl key_get_char

	mov R1, R0
	bl lcd_write_data

	ubfx R1, R1, #0, #4
	bl set_tim2_delay

	bl lcd_clear
	bl enable_interrupt

	b loop


set_buffer_size:
	bl disable_interrupt
	bl lcd_clear
	ldr R1, =set_buffer_size_msg1
	bl lcd_print_string

	bl key_get_char

	mov R1, R0
	bl lcd_write_data

	// update buffer size
	ubfx R1, R1, #0, #4
	ldr R3, =buffer_size
	strb R1, [R3]

	// flush buffer
	mov R1, #0
	ldr R3, =buffer_pos
	strb R1, [R3]

	bl lcd_clear
	bl enable_interrupt

	b loop

.section .data

	.global temp_mode
	.global buffer_mode
	.global buffer_pos
	.global buffer_size
	.global temperature_buffer

	// booleans
	buffer_mode:     .byte 0 // 0->dont write to buffer | 1->write to buffer
	temp_mode:       .byte 0 // 0->Celsius | 1->Fahrenheit
	continuous_mode: .byte 0 // 1-> write values to lcd when calculated

	// integers
	interval:        .byte 1 // [1-9]
	buffer_size:     .byte 10 // [1-9]
	buffer_pos:      .byte 0 // [1-buffer_size]

	.balign 4
	temperature_buffer:
		.space 10

.section .rodata

	set_interval_msg1:     .asciz "Set interval 1-9"
	set_interval_msg2:     .asciz "Interval: "

	set_buffer_size_msg1:  .asciz "Set Buffer Size"

	buffer_mode_on_msg:    .asciz "Buffer Mode On"
	buffer_mode_flush_msg: .asciz "Press A to exit"
