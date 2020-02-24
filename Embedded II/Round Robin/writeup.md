```c
/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Entry point and main logic.
  ******************************************************************************
*/

/// Each task get their own timer(s)
///
/// SysTick is reserved for the task switching
///
/// Knight Rider lights use Timer 2
/// LCD+keypad uses Timer 4
/// Console uses no Timer
/// Music Box uses Timer 3 and 10
///
/// Run the help command to see available commands

#include "robin.h"
#include "led.h"
#include "timer.h"
#include "lcd.h"
#include "keypad.h"
#include "uart_driver.h"
#include "music.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int read_mem(int);
void write_mem(int, int);
void dump_mem(int, int);
int check_addr(int);
void help(void);

NOTE* cur_song;

NOTE imperial_march[] = {
	{A3, QU},
	{A3, QU},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},
	{E4, QU},
	{E4, QU},
	{E4, QU},
	{F4, E + S},
	{C4, S},
	{Ab3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},
	{A4, QU},
	{A3, E + S},
	{A3, S},
	{A4, QU},
	{Ab4, E + S},
	{G4, S},
	{Gb4, S},
	{E4, S},
	{F4, E},

	{0, E + S},

	{Bb3, E},
	{Eb4, QU},
	{D4, E + S},
	{Db4, S},
	{C4, S},
	{B3, S},
	{C4, E},

	{0, E},

	{F3, E},
	{Ab3, QU},
	{F3, E + S},
	{A3, S},
	{C4, QU},
	{A3, E + S},
	{C4, S},
	{E4, H},
	{A4, QU},
	{A3, E + S},
	{A3, S},
	{A4, QU},
	{Ab4, E + S},
	{G4, S},
	{Gb4, S},
	{E4, S},
	{F4, E},

	{0, E},

	{Bb3, E},
	{Eb4, QU},
	{D4, E + S},
	{Db4, S},
	{C4, S},
	{B3, S},
	{C4, E},

	{0, E},

	{F3, E},
	{Ab3, QU},
	{F3, E + S},
	{C4, S},
	{A3, QU},
	{F3, E + S},
	{C4, S},
	{A3, H},

	NOTE_END,
};

// Controls lights
void t1() {
	int number = 1;

	while (1) {
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			led_delay();
			number = number << 1;
		}
		for (int i = 0; i < 9; i++) {
			light_LED(number);
			led_delay();
			number = number >> 1;
		}
	}
}

// controls lcd + keypad
void t2() {
	while(1) {
		char letter = keypad_getchar();

		switch (letter) {
			case '*':
				lcd_clear();
				break;
			case '#':
				lcd_home();
				break;
			default:
				lcd_print_char(letter);
				break;
		}
	}
}

// Console
void t3() {
	char input[30];
	char cmd[5];
	int address, len, val;

	while (1) {
		fgets(input, 30, stdin); // gets input from console.

		if (starts_with(input, "rm")) {
			sscanf(input, "%s %x", cmd, &address); // fetch data from input.
    		if (check_addr(address)) {
    	    	int value = read_mem((uint32_t)address);
    	    	printf("0x%x\n", value);
    	  	}
		} else if (starts_with(input, "wm")) {
			val = 0;
    		sscanf(input, "%s %x %x", cmd, &address, &val); // fetch data from input.
    		if (check_addr(address)) {
    			write_mem(address, val);
    			printf("write 0x%x with 0x%x\n", address, val);
    		}
		} else if (starts_with(input, "dm")) {
			sscanf(input, "%s %x %d", cmd, &address, &len); // fetch data from input.
    		// Determine if the length is reasonable.
    		if (len > 100 || len < 0) {
    			len = 16;
    		}
    		if (check_addr(address)) {
    			dump_mem(address, len);
    			printf("\n");
    		}
		} else if (starts_with(input, "play")) {
			start_song();
		} else if (starts_with(input, "pause")) {
			pause();
		} else if (starts_with(input, "resume")) {
			resume();
		} else if (starts_with(input, "replay")) {
			replay();
		} else if (starts_with(input, "help")) {
			help();
		}
	}
}

// music box
void t4() {
	init_music();
	cur_song = imperial_march;

	while (1);
}

int main(void) {
	init_tasker(5, 10);
	init_task(1, 1000, t1, 5);
	init_task(2, 1000, t2, 5);
	init_task(3, 1000, t3, 5);
	init_task(4, 1000, t4, 5);

	LED_INIT();
	lcd_init();
	keypad_init();
	init_usart2(19200, 16000000);
	SysTick_Init();

	while(1);
}

```

```c
/**
  ******************************************************************************
  * @file    robin.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Contains logic for round robin task switching.
  ******************************************************************************
*/

#include "robin.h"
#include <stdlib.h>

#define STK_BASE (int *) 0xE000E010
#define STK_CLK_SOURCE (int *) 0xE000E012
#define STK_LOAD (int *) 0xE000E014

static int num_tasks;
static task* tasks;
static int current_task;
static int next_task;

static int* scb_icsr = (int*) SCB_ICSR;

void init_tasker(int total_tasks, int main_ticks) {
	num_tasks = total_tasks;

	tasks = calloc(total_tasks, sizeof(task));

	tasks[0].state = ACTIVE;
	tasks[0].ticks_starting = main_ticks;
	tasks[0].ticks_remaining = main_ticks;

	current_task = 0;
}

void init_task(int task_num, int stack_size, void(*entry_point)(void), int ticks) {
    tasks[task_num].stack_pointer = (int*) malloc(stack_size*sizeof(int));

    // point stack to the top of block
    tasks[task_num].stack_pointer += stack_size;

    // Fill stack
    *(--tasks[task_num].stack_pointer) = 0x01000000; // PSR
    *(--tasks[task_num].stack_pointer) = (int) entry_point; // PC
    *(--tasks[task_num].stack_pointer) = 0xFFFFFFFF; // LR
    *(--tasks[task_num].stack_pointer) = 0; // R12
    *(--tasks[task_num].stack_pointer) = 0; // R3
    *(--tasks[task_num].stack_pointer) = 0; // R2
    *(--tasks[task_num].stack_pointer) = 0; // R1
    *(--tasks[task_num].stack_pointer) = 0; // R0
    *(--tasks[task_num].stack_pointer) = 0xFFFFFFF9; // ISR LR
    *(--tasks[task_num].stack_pointer) = 0; // R11
    *(--tasks[task_num].stack_pointer) = 0; // R10
    *(--tasks[task_num].stack_pointer) = 0; // R9
    *(--tasks[task_num].stack_pointer) = 0; // R8
    *(--tasks[task_num].stack_pointer) = 0; // R7
    *(--tasks[task_num].stack_pointer) = 0; // R6
    *(--tasks[task_num].stack_pointer) = 0; // R5
    *(--tasks[task_num].stack_pointer) = 0; // R4

    tasks[task_num].state = ACTIVE;
    tasks[task_num].ticks_starting = ticks;
    tasks[task_num].ticks_remaining = 0;
}

void tasker_tick(void) {
    tasks[current_task].ticks_remaining--;

    if (tasks[current_task].ticks_remaining == 0) {
        int i = 1;
        while (tasks[(next_task=(current_task+i)%num_tasks)].state != ACTIVE) {
            i++;
        }

        tasks[next_task].ticks_remaining = tasks[next_task].ticks_starting;

        *scb_icsr |= 1 << PENDSVET;
    }
}

void PendSV_Handler(void) __attribute__((naked));

void PendSV_Handler(void) {
    register int* stack_pointer asm("r13");

    asm volatile("push {r4-r11,lr}");

    tasks[current_task].stack_pointer = stack_pointer;

    current_task = next_task;
    
    stack_pointer = tasks[current_task].stack_pointer;

    asm volatile("pop {r4-r11, lr}\n\t" "bx lr");
}

void SysTick_Init() {
	*STK_BASE = 0;       // disable clock
	*STK_CLK_SOURCE = 0; // use system clock
	*STK_LOAD = 100;     // set delay
	*STK_BASE |= 1 << 1; // enable interrupt
	*STK_BASE |= 1;      // enable the clock.
}

void SysTick_Handler(void) {
	tasker_tick();
}

```


```c
/**
  ******************************************************************************
  * @file    console.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Contains memory functions used by the console.
  ******************************************************************************
*/

#include "stdio.h"

/**
 * Gets a value from memory
 * 
 * @param address the address to read from
 * @returns the value of memory at address
 */
int read_mem(int address) {
    volatile int *ptr = (int *)address;
    int value = *ptr;
    return value;
}

/**
 * Writes some value to a location in memory
 * 
 * @param address the location to write to
 * @param value the value to write
 */
void write_mem(int address, int value) {
    volatile int *address_pouint32_ter = (int *)address;
    *address_pouint32_ter = value;
}

/**
 * Dumps some length of memory to stdout
 * 
 * @param address the address to start the dump
 * @param length the number of bytes to dump
 */
void dump_mem(int address, int length) {
    volatile char *address_pointer = (char *)address;
    for (int i = 0; i < length; i++) {
        // determine if the next line is reached.
        if (i % 16 == 0) {
            printf("\n0x%x:", (int)address);
            address += 0x10;
        }
        char byte = address_pointer[i]; // get the current byte.
        printf(" ");
        // handle byte '0'.
        if (byte < 0x10) {
            printf("0");
        }
        printf("%x", byte);
    }
}

/**
 * Checks if a number is a valid memory address
 * 
 * @param address the address to check
 * @returns 1 if address is valid else 0
 */
int check_addr(int address) {
    int valid = 1;
    if (address < 0) {
        valid = 0;
        printf("The address cannot be negative, and the number might be overflow!\n");
    }
    else if (address % 4 != 0) {
        valid = 0;
        printf("The address must be a multiple of 4!\n");
    }
    return valid;
}

void help(void) {
    printf("Valid commands are:\n");
    printf("\trm: reads from memory {address} | ex: rm 0x20001000\n");
    printf("\twm: write something to memory {address} {value} | ex: wm 0x20001000 0x7\n");
    printf("\tdm: dumps some number of bytes {address} {length} | ex: dm 0x20001000 100\n");
    printf("\tplay: plays Imperial March\n");
    printf("\tpause: pauses the song\n");
    printf("\tresume: resumes the song\n");
    printf("\treplay: restarts the song\n");
}

/**
 * Helper function to determine if a string starts with some substring
 * 
 * @param string the string
 * @param prefix the substring
 * @returns 1 if string starts with prefix else 0
 */
int starts_with(const char* string, const char* prefix) {
    while(*prefix) {
        if (*prefix++ != *string++)
            return 0;
    }

    return 1;
}
```


```c
/**
  ******************************************************************************
  * @file    music.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Allows the playing of music.
  ******************************************************************************
*/

#include "music.h"
#include "timer.h"
#include "register.h"
#include <stdio.h>

static int* RCC = (int*) RCC_BASE;
static int* GPIOB = (int*) GPIOB_BASE;

static TIM *tim3 = (TIM*) TIM3_BASE;
static TIM *tim10 = (TIM*) TIM10_BASE;

static NOTE* start_of_song;

void init_music(void) {
    // Setup timers
    init_tim3();
    init_tim10();
    set_psc(tim10, 830);
    enable_tim10_int(tim10);

    // Have tim3 use Output Compare
    tim3->CCR1 = 0;
    tim3->CCMR1 = (0b011<<4);
    tim3->CCER = 1;

    // setup speaker
    RCC[AHB1ENR] |= GPIOBEN;
    GPIOB[AFRL] |= (0b0010<<16);
    GPIOB[MODER] |= (0b10<<8);
}

void start_song(void) {
    start_of_song = cur_song;
    if (cur_song->freq != 0 && cur_song->len != 0) {
        start(tim10);
    } else {
        printf("Cannot start the song. Try running replay instead.");
    }
}

void pause(void) {
    stop(tim3);
    stop(tim10);
}

void resume(void) {
    start(tim3);
    start(tim10);
}

void replay(void) {
    stop(tim3);
    stop(tim10);
    cur_song = start_of_song;
    start(tim3);
    start(tim10);
}

// Sets the frequency of the next Note
static void change_freq(int freq) {
    set_arr(tim3, freq);
}

// Sets the duration of the next Note
static void change_delay(int len) {
    set_arr(tim10, len);
}

// Handles interrupt for Timer 10. Interrupt fires whenever a note has finished playing
void TIM1_UP_TIM10_IRQHandler(void) {
    tim10->SR &= ~1;

    stop(tim10);
    stop(tim3);

    // Add a bit of delay between notes
    for (int i=0; i<1500; i++);

    if (cur_song->len != 0) {
        int freq = cur_song->freq;
        int len = cur_song->len;

        int arr_val = freq != 0 ? 16000000 / (2 * freq) : 0;
        int del = len * 20;

        // change note frequency
        change_freq(arr_val);

        // change note duration
        change_delay(del);

        // startup the timers
        start(tim3);
        start(tim10);

        // inc pointer
        cur_song++;
    }
}
```


```c
/**
  ******************************************************************************
  * @file    timer.c
  * @author  John Bretz
  * @version V1.0
  * @brief   basic Timer api.
  ******************************************************************************
*/

#include "timer.h"
#include "register.h"

volatile static int* apb1enr = (int*) RCC_APB1ENR;
volatile static int* apb2enr = (int*) RCC_APB2ENR;
volatile static int* iser0 = (int*) 0xE000E100;

void init_tim2(void) {
    *apb1enr |= 1 << 0;
}

void init_tim3(void) {
    *apb1enr |= 1 << 1;
}

void init_tim4(void) {
    *apb1enr |= 1 << 2;
}

void init_tim10(void) {
    *apb2enr |= 1 << 17;
}

void set_arr(TIM* base, int value) {
    base->ARR = value;
}

void set_psc(TIM* base, int value) {
    base->PSC = value;
}

void start(TIM* base) {
    base->CR1 |= 1;
}

void stop(TIM* base) {
    base->CR1 &= ~1;
}

void enable_tim2_int(TIM* base) {
    base->DIER |= 1;
    *iser0 |= 1<<28;
}

void enable_tim3_int(TIM* base) {
    base->DIER |= 1;
    *iser0 |= 1<<29;
}

void enable_tim4_int(TIM* base) {
    base->DIER |= 1;
    *iser0 |= 1<<30;
}

void enable_tim10_int(TIM* base) {
    base->DIER |= 1;
    *iser0 |= 1<<25;
}

```


```c
/**
  ******************************************************************************
  * @file    led.c
  * @author  John Bretz
  * @version V1.0
  * @brief   LED api.
  ******************************************************************************
*/

#include "timer.h"

#define RCC_AHB1ENR (int *) 0x40023830
#define GPIOB_MODER (int *) 0x40020400
#define GPIOB_ODR (int *) 0x40020414

#define GPIOB_ENABLE 0x2

static TIM* tim2 = (TIM *) TIM2_BASE;
static int led_flag = 0;

void LED_INIT(void) {
	// turn on gpiob
	*RCC_AHB1ENR |= GPIOB_ENABLE;

	// set pb5-10, pb12-15 to output
	*GPIOB_MODER |=  0x55155400;
	*GPIOB_MODER &= ~0xAA2AA800;

	// setup timer
	init_tim2();
	enable_tim2_int(tim2);
	set_psc(tim2, 16000 - 1);
}

void light_LED(int number) {
	*GPIOB_ODR &= ~0xF7E0; // turn off all leds

	*GPIOB_ODR |= (number & 0x3F)  << 5; // bottom 6 bits
	*GPIOB_ODR |= (number & 0x3C0) << 6; // top 4 bits
}

void light(int led, int status) {
	if (status) {
		// enable
		*GPIOB_ODR |= ((1 << led) & 0x3F)  << 5; // bottom 6 bits
		*GPIOB_ODR |= ((1 << led) & 0x3C0) << 6; // top 4 bits
	} else {
		// disable
		*GPIOB_ODR &= ~(((1 << led) & 0x3F)  << 5); // bottom 6 bits
		*GPIOB_ODR &= ~(((1 << led) & 0x3C0) << 6); // top 4 bits
	}
}

void led_delay(void) {
	led_flag = 0;
	set_arr(tim2, 100);
	start(tim2);
	while (!led_flag);
}

void TIM2_IRQHandler(void) {
	tim2->SR &= ~1;
	stop(tim2);
	led_flag = 1;
}
```

```c
/**
 * Robin.h
 */
typedef enum {PAUSED, ACTIVE} task_state;

#define SCB_ICSR 0xE000ED04
#define PENDSVET 28

typedef struct {
	int* stack_pointer;
	task_state state;
	int ticks_starting;
	int ticks_remaining;
} task;

void tasker_tick(void);
void init_tasker(int total_tasks, int main_ticks);
void init_task(int task_num, int stack_size, void(*entry_point)(void), int ticks);
void SysTick_Init(void);
```

```c
/**
 * Timer.h
 */
#ifndef TIMER_H
#define TIMER_H

typedef struct {
	int CR1;
	int CR2;
	int SMCR;
	int DIER;
	int SR;
	int EGR;
	int CCMR1;
	int CCMR2;
	int CCER;
	int CNT;
	int PSC;
	int ARR;
	int RCR;
	int CCR1;
	int CCR2;
	int CCR3;
	int CCR4;
	int BDTR;
	int DCR;
	int DMAR;
} TIM;

#define TIM1_BASE 0x40010000
#define TIM2_BASE 0x40000000
#define TIM3_BASE 0x40000400
#define TIM4_BASE 0x40000800
#define TIM5_BASE 0x40000C00
#define TIM6_BASE 0x40001000
#define TIM10_BASE 0x40014400

void init_tim2(void);
void init_tim3(void);
void init_tim4(void);
void init_tim10(void);

void enable_tim2_int(TIM*);
void enable_tim3_int(TIM*);
void enable_tim4_int(TIM*);
void enable_tim10_int(TIM*);

void set_arr(TIM*, int);
void set_psc(TIM*, int);
void start(TIM*);
void stop(TIM*);

#endif
```

```c
/**
 * Register.h
 */


#define RCC_BASE 0x40023800
#define RCC_APB1ENR 0x40023840
#define RCC_APB2ENR 0x40023844
#define RCC_AHB1ENR 0x40023830
#define NVIC_BASE 0xE000E000

#define ISER0_OFF 0x100

#define GPIOA_BASE 0x40020000
#define GPIOB_BASE 0x40020400
#define GPIOC_BASE 0x40020800

#define RCC_BASE 0x40023800

#define GPIOAEN 1<<0
#define GPIOBEN 1<<1
#define GPIOCEN 1<<2

#define AHB1ENR 0x0C

#define MODER 0
#define PUPDR 3
#define IDR   4
#define ODR   5
#define BSRR  6
#define AFRL  8
```

