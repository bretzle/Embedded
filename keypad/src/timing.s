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
