.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global num_to_ASCII
.global byte_to_ASCII
.global num_to_bcd

@ input : R0
@ output: R0
num_to_ASCII:
	bx   LR

@ Input : R1
@ Output: R1
byte_to_ASCII:
	push {LR}

	orr  R1, R1, 0x30

	pop  {PC}

@ Input : R1  only accepts 12 bit numbers
@ output: R0  stores bcd
@ temp  : R2  bit counter
@ temp  : R3  copy of input
@ temp  : R4  used by bit field extract
@ temp  : R5  used for checking bcd
num_to_bcd:
	push {R2-R5, LR}
	mov R0, #0          @ BCD will be stored here
	mov R2, #12         @ bit counter
	lsl R3, R1, #20		@ copy input to a mutable register

loop:
	@bl check_bcd
	@lsl R0, R0, #1 	    @ shift bcd
	@ubfx R4, R1, #0, #1 @ get lsb of input
	@add R0, R0, R4      @ add to bcd

	@lsr R1, R1, #1
	@lsl R3, R3, #1      @ shift input

	@subs R2, R2, #1
	@bne  loop

	@bl check_bcd

	bl check_bcd

	lsl R0, R0, #1
	ubfx R4, R3, #31, #1
	add R0, R0, R4

	lsl R3, R3, #1

	subs R2, R2, #1
	bne loop
	
	pop  {R2-R5, PC}

check_bcd:
	push {LR}

	@ ones
	ubfx R5, R0, #0, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #3

	@ tens
	ubfx R5, R0, #4, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x30

	@ hundreds
	ubfx R5, R0, #8, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x300

	pop {PC}
