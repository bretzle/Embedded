@ timing.s
@ John Bretz
@ CE 2801
@ Lab 3
@ Description: time related subroutines

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ INST_MS, 0x148F @ instructions to run in one ms

.global busy_delay_ms

@ runs a busy loop that will last X ms
@
@ input : R1
@ temp  : R2 counter
busy_delay_ms:
	push {R2, LR}
2:
    mov  R2, INST_MS
1:
    subs R2, R2, #1  @ decrement instruction counter
    bne  1b
    subs R1, R1, #1  @ 1 ms has elapsed
    bne  2b
    pop  {R1, PC}
