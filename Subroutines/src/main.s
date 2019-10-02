@ main.s
@ John Bretz
@ CE 2801
@ Lab 3
@ Description: Subroutines

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

@ convert 1234 to bcd
@ convert each column to ascii
@ print each ascii code to led with 500ms delay

main:
    bl LED_init
	mov R1, #9999

	bl num_to_bcd
	mov R1, R0

	bl bcd_to_ascii

loop:
	ubfx R1, R0, #24, #8 @
	bl num_to_LED        @
	mov R1, #500         @
	bl busy_delay_ms     @ print first byte

	ubfx R1, R0, #16, #8 @
	bl num_to_LED        @
	mov R1, #500         @
	bl busy_delay_ms     @ print second byte

	ubfx R1, R0, #8, #8  @
	bl num_to_LED        @
	mov R1, #500         @
	bl busy_delay_ms     @ print third byte

	ubfx R1, R0, #0, #8  @
	bl num_to_LED        @
	mov R1, #500         @
	bl busy_delay_ms     @ print fourth byte

	b loop
