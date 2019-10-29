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

.global one_sec_delay_by_using_systick
.global reset_bits_for_systick
.global delay_ms
.global delay_us

// runs a busy loop that will last X ms
//
// R2 : input : num of ms
// R3 : temp  : counter
delay_ms:
    push {R2, R3, LR}
2:
    mov  R3, INST_MS
1:
    subs R3, R3, #1  // decrement instruction counter
    bne  1b
    subs R2, R2, #1  // 1 ms has elapsed
    bne  2b
    pop  {R2, R3, PC}

// runs a busy loop that will last X us
//
// R1 : input : num of us
delay_us:
	push {R1, LR}

	lsl R1, R1, #3

1:
	subs R1, R1, #1
	bne 1b

	pop {R1, PC}

reset_bits_for_systick:
	push {r0-r1,lr}

	# reset all bits.
	ldr r0,=SYSTICK_BASE
	ldr r1,[r0,STK_CTRL]
	and r1,r1,#0
	str r1,[r0,STK_CTRL]
	ldr r1,[r0,STK_LOAD]
	and r1,r1,#0
	str r1,[r0,STK_LOAD]

	pop {r0-r1,pc}

# Cause a delay for 1 second by using systick counter.
one_sec_delay_by_using_systick:
	push {r0-r1,lr}

	bl reset_bits_for_systick

	# cause a delay by using the systick.
	ldr r0,=SYSTICK_BASE
	ldr r1,=16000000
	str r1,[r0,STK_LOAD]
	# start the clock.
	mov r1,ENABLE|CLKSOURCE
	str r1,[r0,STK_CTRL]
	# determine when is timeout.
1:
	ldr r1,[r0,STK_CTRL]
	ands r1,r1,COUNTFLAG
	beq 1b

	pop {r0-r1,pc}
