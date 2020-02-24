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
