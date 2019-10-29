// timing.s
// John Bretz
// CE 2801
// Lab 4
// Description: time related subroutines

.syntax unified
.cpu cortex-m4
.thumb
.section .text

    .equ INST_MS, 0x148F // instructions to run in one ms

    .equ SYSTICK_BASE, 0xE000E010
	.equ STK_CTRL, 0x00
	.equ STK_LOAD, 0x04
	.equ STK_VAL, 0x08
	.equ STK_CALIB, 0x0C
	.equ COUNTFLAG, 1<<16
	.equ CLKSOURCE, 1<<2
	.equ TICKINT, 1<<1
	.equ ENABLE, 1<<0

.global delay_one_sec
.global delay_ms
.global delay_us

// delay that will last X ms
//
// R1 : input : num of ms
delay_ms:
    push {R0-R2, LR}

	bl reset_bits_for_systick

	# cause a delay by using the systick.
	ldr R0, =SYSTICK_BASE
	ldr R2, =16000
	mul R2, R2, R1
	str R2, [R0, STK_LOAD]
	# start the clock.
	mov R2, ENABLE|CLKSOURCE
	str R2, [r0,STK_CTRL]
	# determine when is timeout.
1:
	ldr R2, [R0, STK_CTRL]
	ands R2, R2, COUNTFLAG
	beq 1b

	pop {R0-R2, PC}

// delay that will last X us
//
// R1 : input : num of us
delay_us:
	push {R0-R2, LR}

	bl reset_bits_for_systick

	# cause a delay by using the systick.
	ldr R0, =SYSTICK_BASE
	ldr R2, =16
	mul R2, R2, R1
	str R2, [R0, STK_LOAD]
	# start the clock.
	mov R2, ENABLE|CLKSOURCE
	str R2, [r0,STK_CTRL]
	# determine when is timeout.
1:
	ldr R2, [R0, STK_CTRL]
	ands R2, R2, COUNTFLAG
	beq 1b

	pop {R0-R2, PC}

reset_bits_for_systick:
	push {R0-R1, LR}

	# reset all bits.
	ldr R0, =SYSTICK_BASE
	ldr R1, [R0, STK_CTRL]
	and R1, R1, #0
	str R1, [R0, STK_CTRL]
	ldr R1, [R0, STK_LOAD]
	and R1, R1, #0
	str R1, [R0, STK_LOAD]

	pop {R0-R1, PC}

# Cause a delay for 1 second by using systick counter.
delay_one_sec:
	push {R0-R1, LR}

	bl reset_bits_for_systick

	# cause a delay by using the systick.
	ldr R0, =SYSTICK_BASE
	ldr R1, =16000000
	str R1, [R0, STK_LOAD]
	# start the clock.
	mov R1, ENABLE|CLKSOURCE
	str R1, [r0,STK_CTRL]
	# determine when is timeout.
1:
	ldr R1, [R0, STK_CTRL]
	ands R1, R1, COUNTFLAG
	beq 1b

	pop {R0-R1, PC}
