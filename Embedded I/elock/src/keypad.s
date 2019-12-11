# keypad.s
# John Bretz
# CE 2801
# Lab 5
# Description: keypad api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE, 0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOCEN, 0x4

	.equ GPIOC_BASE, 0x40020800

	.equ GPIO_MODER, 0x0
	.equ GPIO_IDR, 0x10
	.equ GPIO_ODR, 0x14
	.equ GPIO_PUPDR, 0xC

	.equ BSRR_OFFSET, 0x18

.global key_init
.global key_get_key_no_block
.global key_get_key
.global key_get_char

@ initialize pins for the keypad
key_init:
	push {R1-R2, LR}

	ldr R1, =RCC_BASE

	@ enable gpio bus
	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, RCC_GPIOCEN
	str R2, [R1, #RCC_AHB1ENR]

	@ set pin 0-3 to input
	ldr R1, =GPIOC_BASE
	ldr R2, [R1, GPIO_MODER]
	orr R2, R2, #0x55
	bic R2, R2, #0xAA
	str R2, [R1, #GPIO_MODER]

	@ set pin 4-7 to output
	ldr R1, =GPIOC_BASE
	ldr R2, [R1, GPIO_PUPDR]
	orr R2, R2, 0x5500
	str R2, [R1, #GPIO_PUPDR]

	pop  {R1-R2, PC}

@ Gets the key that was pressed (1-16)
@
@ R0 : output : keycode else 0
@ R3 : temp   : current column
@ R2 : temp   : current row
key_get_key_no_block:
	push {R1-R5, R12, LR}

	// R3 record current column
	mov R3, #4
	// starting value of C0-C3
	mov R4, #7
	// starting value of C4-C7
	mov R5, #7

change_to_next_col:
	// R2, record current row
	mov R2, #4

	// update odr
	ldr R0, =GPIOC_BASE
	ldr R1, [R0, GPIO_ODR]
	bic R1, R1, #0xF
	orr R1, R1, R4
	str R1, [R0, GPIO_ODR]

	// some delay
	mov R1, #10
	bl delay_us

change_to_next_row:

	ldr R1, [R0, GPIO_IDR]
	bic R1, R1, #0xFFFFFF0F
	lsr R1, R1, #4

	// is a button pressed in row?
	cmp R1, R5
	beq generate_num_code

	// update output
	ror R5, R5, #1
	bic R12, R5, #0xFFFFFFF0
	bic R5, R5, #0x0FFFFFFF
	lsr R5, R5, #28
	add R5, R5, R12


	// iterate over each row
	sub R2, R2, #1
	cmp R2, #0
	beq update_cond_for_next_col
	b change_to_next_row

update_cond_for_next_col:
	// update the condition.
	ror R4, R4, #1
	bic R12, R4, #0xFFFFFFF0
	bic R4, R4, #0x0FFFFFFF
	lsr R4, R4, #28
	add R4, R4, R12

	sub R3, R3, #1
	cmp R3, #0
	bne change_to_next_col

generate_num_code:

	// determine if a key was pressed
	cmp R3, #0
	beq 1f

	// calculate the keycode
	sub R2, R2, #1
	mov R1, #4
	mul R0, R2, R1

	// R0 now has the keycode
	add R0, R0, R3
	b 2f

1:
	// no key was pressed
	mov R0, #0

2:
	ldr R2, =GPIOC_BASE

key_not_released:
	// dont return until key has been released
	ldr R1, [R2, GPIO_IDR]
	bic R1, R1, 0xFFFFFF0F
	lsr R1, R1, #4
	cmp R1, #0b1111
	bne key_not_released

	pop {R1-R5, R12, PC}

@ Waits until a key is pressed and returns the key
@
@ R0 : output : key
key_get_key:
	push {LR}

1:
	bl key_get_key_no_block
	cmp R0, #0
	beq 1b

	pop  {PC}

@ Waits until a key is pressed and returns the ascii value of the key
@
@ R0 : output : ascii value of key
@ R1 : temp   : current keycode
@ R3 : temp   : memory offset for keycode
key_get_char:
	push {R1-R3, LR}

	bl key_get_key
	mov R1, #1
	ldr R2, =button1
	mov R3, #0

1:
	cmp R0, R1
	beq 1f

	// inc desired keycode
	// inc memory offset
	add R1, R1, #1
	add R3, R3, #2
	b 1b

1:
	ldrh R1, [R2, R3]
	mov R0, R1

	pop  {R1-R3, PC}

.section .rodata
	button1:      .hword 0x31
	button2:      .hword 0x32
	button3:      .hword 0x33
	buttonA:      .hword 0x41
	button4:      .hword 0x34
	button5:      .hword 0x35
	button6:      .hword 0x36
	buttonB:      .hword 0x42
	button7:      .hword 0x37
	button8:      .hword 0x38
	button9:      .hword 0x39
	buttonC:      .hword 0x43
	buttonFlower: .hword 0x2A
	button0:      .hword 0x30
	buttonNum:    .hword 0x23
	buttonD:      .hword 0x44
