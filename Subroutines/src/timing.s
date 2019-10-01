.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ INST_MS,     0x148F // instructions to run in one ms

.global busy_delay_ms

# runs a busy loop that will last R0 ms
busy_delay_ms:
	push {R1, LR}
    mov  R1, INST_MS
1:
    subs R1, R1, #1
    bne  1b
    subs R0, R0, #1
    bne  delay_ms
    pop  {R1, PC}
