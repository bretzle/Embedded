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
	bl led_init
	bl lcd_init
	bl lcd_clear
	bl lcd_home
	bl key_init
	bl timer3_init

	# clean history
	bl clear_previous_password
	bl prompt_enter

	# verify password
	bl check_password
	cmp R0, #1
	bne play_wrong_password_sound

	# turn on led
	bl turn_on_edge_led

	# make the sound when password is correct
	movw R1, #16000
	bl set_timer3
	bl enable_tim3
	bl delay_one_sec
	bl disable_tim3

	movw R1, #8000
	bl set_timer3
	bl enable_tim3
	bl delay_one_sec
	bl disable_tim3

	# turn off the led.
	bl turn_off_edge_led
	b end

play_wrong_password_sound:
	# make the sound when the wrong password typed in.
	movw R1, #8000
	bl set_timer3
	bl enable_tim3
	bl delay_one_sec
	bl disable_tim3

	movw R1, #16000
	bl set_timer3
	bl enable_tim3
	bl delay_one_sec
	bl disable_tim3

end:
	b main

prompt_enter:
	push {R0-R2, LR}

	ldr R1, =message_for_enter_password
	bl lcd_print_string
	# set the position to the next line.
	mov R0, #1
	mov R1, #0
	bl lcd_set_position
	mov R2, #7
	# offset of the memory.
	mov R3, #0

repeat_7_times:
	# store the one character of the password into the memory.
	bl key_get_char
	ldr R1, =entered_password
	strb R0, [R1, R3]
	# the ascii value of the key is stored in r0.
	mov R1, '*'
	bl lcd_write_data
	subs R2, R2, #1
	add R3, R3, #1
	bne repeat_7_times

	pop {R0-R2, PC}

# The subroutine checks if the password is right or wrong.
# Returns:
# r0: 	1 if the password is correct.
# 		0 if the password is incorrect.
check_password:
	push {R1-R4, LR}

	# r0 for the address of the password
	# that the user entered.
	ldr R0, =entered_password
	# r1 for the address of the expect password.
	ldr R1, =password

	mov R4, #0
next_character:
	ldrb R2, [R0, R4]
	ldrb R3, [R1, R4]
	# compare each character of the password.
	cmp R2, R3
	bne incorrect_password
	add R4, R4, #1
	cmp R4, #8
	bne next_character

	b correct_password

incorrect_password:
	mov R0, #0
	b 1f
correct_password:
	mov R0, #1
1:
	pop {R1-R4, PC}

# Clear the memory which stores the previous password entered.
clear_previous_password:
	push {R0-R2, LR}

	ldr R0, =entered_password
	mov R2, #0
1:
	ldrb R1,[R0, R2]
	# clear password.
	and R1, R1, #0
	strb R1, [R0, R2]
	add R2, R2, #1
	cmp R2, #8
	bne 1b

	pop {R0-R2, PC}

.section .rodata
# The correct password.
message_for_enter_password:
	.asciz "Enter Password:"
password:
	.asciz "123A456"

.section .bss
entered_password:
	.space 7
