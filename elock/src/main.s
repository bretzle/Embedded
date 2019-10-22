# main.s
# John Bretz
# CE 2801
# Lab 6
# Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

main:
	bl key_init
	bl lcd_init

	ldr R1, =prompt
	bl lcd_print_string

	mov R0, #1
	mov R1, #0
	bl lcd_set_position

	// base address to store entered password
	ldr R3, =userp
	// offset
	mov R4, #0
	mov R1, '*'

1:
	bl key_get_char
	cmp R0, '*'
	beq check_password

	bl lcd_write_data
	strb R0, [R3, R4]
	add R4, R4, #1
	b 1b

check_password:
	ldr R1, =userp
	ldr R2, =passw

	// offset
	mov R5, #0

1:
	ldrb R3, [R1, R5] // user
	ldrb R4, [R2, R5] // pass

	cmp R3, R4
	bne wrong_password

	cmp R4, #0
	beq correct_password

	add R5, R5, #1

	b 1b

wrong_password:
	ldr R1, =nay
	bl lcd_clear
	bl lcd_print_string

	bl play_bad_sound

	b end

correct_password:
	ldr R1, =yay
	bl lcd_clear
	bl lcd_print_string

	bl energize_led
	bl play_good_sound

end:
	b end


energize_led:
	push {LR}
	pop  {PC}

play_bad_sound:
	push {LR}
	pop  {PC}

play_good_sound:
	push {LR}
	pop  {PC}

.data

	prompt: .asciz "Enter password"

	passw: .asciz "1234"

	yay: .asciz "Success"

	nay: .asciz "Failure"

	userp: .asciz ""
