/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Tests that ring buffer functions properly.
  ******************************************************************************
*/

#include "ring_buffer.h"
#include "uart_driver.h"
#include <stdio.h>

#define F_CPU 16000000UL

static char buffer[30];

// main
int main() {

    init_usart2(19200, F_CPU);

    while (1) {
    	printf("What is your name?\n");
    	scanf("%s", buffer);
    	printf("Your name is %s.\n", buffer);
    }

    return 0;
}
