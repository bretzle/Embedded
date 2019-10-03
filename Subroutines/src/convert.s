@ convert.s
@ John Bretz
@ CE 2801
@ Lab 3
@ Description: convert binary number into other formats

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ ERR, 0x4552522E

.global num_to_bcd
.global bcd_to_ascii

@ Converts a 28-bit binary number into 32-bit BCD
@
@ Input : R1  28 bit binary number
@ output: R0  stores bcd
@ temp  : R2  bit counter
@ temp  : R3  copy of input
@ temp  : R4  used by bit field extract
@ temp  : R5  used for checking bcd
num_to_bcd:
	push {R2-R5, LR}
	mov R0, #0            @ BCD will be stored here
	mov R2, #28           @ bit counter
	lsl R3, R1, #4		  @ copy input to a mutable register

1:
	bl check_bcd          @ add 3 to any columns who > 4

	lsl R0, R0, #1        @ shift bcd
	ubfx R4, R3, #31, #1  @ get msb of input
	add R0, R0, R4        @ make msb of input lsb of bcd

	lsl R3, R3, #1        @ shift input

	subs R2, R2, #1       @ decrement counter
	bne 1b
	
	pop  {R2-R5, PC}

check_bcd:
	push {LR}

	@ ones
	ubfx R5, R0, #0, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #3      @ add 3 to columns if > 4

	@ tens
	ubfx R5, R0, #4, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x30   @ add 3 to column if > 4

	@ hundreds
	ubfx R5, R0, #8, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x300  @ add 3 to column if > 4

	@ thousands
	ubfx R5, R0, #12, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x3000 @ add 3 to column if > 4

	@ ten-thousands
	ubfx R5, R0, #12, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x30000 @ add 3 to column if > 4

	@ hundred-thousands
	ubfx R5, R0, #12, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x300000 @ add 3 to column if > 4

	@ millions
	ubfx R5, R0, #12, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x3000000 @ add 3 to column if > 4

	pop {PC}

@ convert a 16 bit bcd number to ascii
@
@ input  : R1
@ output : R0
@ temp   : R2  store temp bit field extracts
bcd_to_ascii:
	push {R2, LR}

	lsl R2, R1, #16 @
	lsr R2, R2, #16 @
	cmp R2, R1      @
	ldr R0, =ERR    @ verify bcd is 16 bit.
	bne 1f          @ if it isnt return 'Err.' in ascii

	mov R0, #0x30303030

	ubfx R2, R1, #12, #4
	bfi  R0, R2, #24, #4

	ubfx R2, R1, #8, #4
	bfi  R0, R2, #16, #4

	ubfx R2, R1, #4, #4
	bfi  R0, R2, #8, #4

	ubfx R2, R1, #0, #4
	bfi  R0, R2, #0, #4

1:
	pop  {R2, PC}
