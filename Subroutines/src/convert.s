.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global num_to_bcd
.global bcd_to_ascii

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

	bl check_bcd         @ add 3 to any columns who > 4

	lsl R0, R0, #1       @ shift bcd
	ubfx R4, R3, #31, #1 @ get msb of input
	add R0, R0, R4       @ make msb of input lsb of bcd

	lsl R3, R3, #1       @ shift input

	subs R2, R2, #1      @ decrement counter
	bne loop
	
	pop  {R2-R5, PC}

check_bcd:
	push {LR}

	@ ones
	ubfx R5, R0, #0, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #3     @ add 3 to ones columns if > 4

	@ tens
	ubfx R5, R0, #4, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x30  @ add 3 to tens column if > 4

	@ hundreds
	ubfx R5, R0, #8, #4
	cmp R5, #4
	it gt
	addgt R0, R0, #0x300 @ add 3 to hundreds column if > 4

	pop {PC}

@ convert a 16 bit bcd number to ascii
@ input  : R1
@ output : R0
@ temp   : R2  store temp bit field extracts
bcd_to_ascii:
	push {R2, LR}
	mov R0, #0x30303030

	ubfx R2, R1, #12, #4
	lsl  R2, R2, #24
	orr  R0, R0, R2

	ubfx R2, R1, #8, #4
	lsl  R2, R2, #16
	orr  R0, R0, R2

	ubfx R2, R1, #4, #4
	lsl  R2, R2, #8
	orr  R0, R0, R2

	ubfx R2, R1, #0, #4
	lsl  R2, R2, #0
	orr  R0, R0, R2

	pop  {R2, PC}
