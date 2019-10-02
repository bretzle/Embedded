.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ INST_MS,     0x148F // instructions to run in one ms

.global busy_delay_ms

# runs a busy loop that will last R1 ms
busy_delay_ms:
	push {R2, LR}
2:
    mov  R2, INST_MS
1:
    subs R2, R2, #1
    bne  1b
    subs R1, R1, #1
    bne  2b
    pop  {R1, PC}
