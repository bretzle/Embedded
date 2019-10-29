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
	bl one_sec_delay_by_using_systick
	bl disable_tim3

	movw R1, #8000
	bl set_timer3
	bl enable_tim3
	bl one_sec_delay_by_using_systick
	bl disable_tim3

	# turn off the led.
	bl turn_off_edge_led
	b end

play_wrong_password_sound:
	# make the sound when the wrong password typed in.
	movw r1,#8000
	bl set_timer3
	bl enable_tim3
	bl one_sec_delay_by_using_systick
	bl disable_tim3

	movw r1,#16000
	bl set_timer3
	bl enable_tim3
	bl one_sec_delay_by_using_systick
	bl disable_tim3

end:
	b main

prompt_enter:
	push {r0-r2,lr}

	ldr r1,=message_for_enter_password
	bl lcd_print_string
	# set the position to the next line.
	mov r0,#1
	mov r1,#0
	bl lcd_set_position
	mov r2,#7
	# offset of the memory.
	mov r3,#0

repeat_7_times:
	# store the one character of the password into the memory.
	bl key_get_char
	ldr r1,=entered_password
	strb r0,[r1,r3]
	# the ascii value of the key is stored in r0.
	mov r1,'*'
	bl lcd_write_data
	subs r2,r2,#1
	add r3,r3,#1
	bne repeat_7_times

	pop {r0-r2,pc}

# The subroutine checks if the password is right or wrong.
# Returns:
# r0: 	1 if the password is correct.
# 		0 if the password is incorrect.
check_password:
	push {r1-r4,lr}

	# r0 for the address of the password
	# that the user entered.
	ldr r0,=entered_password
	# r1 for the address of the expect password.
	ldr r1,=password

	mov r4,#0
next_character:
	ldrb r2,[r0,r4]
	ldrb r3,[r1,r4]
	# compare each character of the password.
	cmp r2,r3
	bne incorrect_password
	add r4,r4,#1
	cmp r4,#8
	bne next_character

	b correct_password

incorrect_password:
	mov r0,#0
	b 1f
correct_password:
	mov r0,#1
1:
	pop {r1-r4,pc}

# Clear the memory which stores the previous password entered.
clear_previous_password:
	push {r0-r2,lr}

	ldr r0,=entered_password
	mov r2,#0
1:
	ldrb r1,[r0,r2]
	# clear password.
	and r1,r1,#0
	strb r1,[r0,r2]
	add r2,r2,#1
	cmp r2,#8
	bne 1b

	pop {r0-r2,pc}

.section .data
# display message.
message_for_enter_password:
	.asciz "Enter Password:"

.section .rodata
# The correct password.
password:
	.asciz "ABCD123"

.section .bss
entered_password:
	.space 7
