# main.s
# John Bretz
# CE 2801
# Lab 7
# Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global num_ms

.global main

main:
	bl lcd_init
	bl led_init
	bl key_init
	bl tim2_init
	bl stop_tim2

	mov R12, #5

loop:
	bl lcd_clear
	bl lcd_home

	// ready
	ldr R1, =start1
	bl lcd_print_string
	bl delay_one_sec
	bl lcd_clear

	// set
	ldr R1, =start2
	bl lcd_print_string
	bl delay_one_sec
	bl lcd_clear

	// go
	ldr R1, =start3
	bl lcd_print_string
	bl delay_one_sec
	bl lcd_clear

	// write binary number
	bl get_4bit_num
	ldr R0, =input
	ldr R1, [R0]
	bl num_to_LED

	// get key and write to string
	ldr R1, =guess
	bl start_tim2
	bl key_get_char
	bl stop_tim2
	strb R0, [R1]

	// check guess with answer
	ldr R0, =guess
	ldr R1, =answer

	ldrb R0, [R0]
	ldrb R1, [R1]

	cmp R0, R1
	beq correct
	bne incorrect

continue:
	ldr R1, =1000000
	bl delay_us

	ldr R1, =num_ms
	mov R2, #0
	str R2, [R1]

	subs R12, R12, #1
	bne loop

show_score:
	bl lcd_clear

	ldr R1, =score_msg_1
	bl lcd_print_string

	ldr R1, =num_correct
	ldr R1, [R1]
	ubfx R1, R1, #0, #4
	add R1, R1, #0x30
	bl lcd_write_data

	mov R0, #1
	mov R1, #0
	bl lcd_set_position

	ldr R1, =score_msg_2
	bl lcd_print_string

	ldr R1, =fastest_guess
	ldr R1, [R1]
	bl lcd_print_num

end:
	b end


correct:
	ldr R1, =correct_answer
	bl lcd_print_string

	mov R0, #0
	mov R1, #9
	bl lcd_set_position

	ldr R0, =num_ms
	ldr R1, [R0]
	bl lcd_print_num

	ldr R1, =time_suffix
	bl lcd_print_string

	// update number of correct answers
	ldr R0, =num_correct
	ldr R1, [R0]
	add R1, R1, #1
	str R1, [R0]

	// update fastest time
	ldr R0, =num_ms
	ldr R1, =fastest_guess

	ldr R2, [R0]
	ldr R3, [R1]

	cmp R2, R3
	it lt
	strlt R2, [R1]

	b continue

incorrect:
	ldr R1, =incorrect_answer
	bl lcd_print_string
	b continue

get_4bit_num:
	push {R1-R4, LR}

	ldr R1, =answer
	ldr R2, =input

	cmp R12, #5
	itttt eq
	moveq R3, '*'
	moveq R4, #15
	streq R3, [R1]
	streq R4, [R2]

	cmp R12, #4
	itttt eq
	moveq R3, '9'
	moveq R4, #9
	streq R3, [R1]
	streq R4, [R2]

	cmp R12, #3
	itttt eq
	moveq R3, 'B'
	moveq R4, #11
	streq R3, [R1]
	streq R4, [R2]

	cmp R12, #2
	itttt eq
	moveq R3, '3'
	moveq R4, #3
	streq R3, [R1]
	streq R4, [R2]

	cmp R12, #1
	itttt eq
	moveq R3, '6'
	moveq R4, #6
	streq R3, [R1]
	streq R4, [R2]

	pop  {R1-R4, PC}

.section .data
	guess:         .byte 0x0
	answer:        .byte 0x0
	num_ms:        .word 0x0
	fastest_guess: .word 0xFFFF
	num_correct:   .word 0x0

	input:  .byte 0b1010

.section .rodata
	start1: .asciz "Ready."
	start2: .asciz "Set."
	start3: .asciz "Go!"

	correct_answer:   .asciz "Correct"
	incorrect_answer: .asciz "Incorrect"

	time_msg: .asciz "Took "
	time_suffix: .asciz " ms"

	score_msg_1: .asciz "Num correct: "
	score_msg_2: .asciz "Best time: "

