.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global pretty_print
.global is_buffer_mode
.global inc_buffer_pos

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

	mov R1, '~'
	bl lcd_write_data

	bl get_temp_abbr
	bl lcd_write_data

	pop  {R0-R4, PC}

get_temp_abbr:
	push {R0, LR}

	ldr R0, =temp_mode
	ldrb R1, [R0]

	cmp R1, #0
	ite eq
	moveq R1, 'C'
	movne R1, 'F'

	pop  {R0, PC}

is_buffer_mode:
	push {LR}

	ldr R1, =buffer_mode
	ldrb R1, [R1]

	pop  {PC}

inc_buffer_pos:
	push {LR}

	ldr R0, =buffer_pos
	ldrb R1, [R0]

	ldr R2, =buffer_size
	ldrb R2, [R2]

	cmp R2, R1
	ite eq
	moveq R1, #0
	addne R1, R1, #1

	strb R1, [R0]

	pop  {PC}
