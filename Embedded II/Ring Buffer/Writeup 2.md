```c
/*
 * uart_driver.c
 *
 *  Created on: Nov 8, 2016
 *      Author: barnekow, John Bretz
 */
#include "uart_driver.h"
#include "ring_buffer.h"
#include <inttypes.h>
#include <stdio.h>

static RingBuffer recieve = {0, 0, 0};
static RingBuffer transmit = {0, 0, 0};

// Overwrites _read in  syscall
int _read(int file, char* ptr, int len) {
    int DataIdx;

    int byteCnt = 0;
    for (DataIdx = 0; DataIdx < len; DataIdx++) {
        byteCnt++;
        *ptr = usart2_getch();
        if (*ptr == '\n') break;
        ptr++;
    }

    return byteCnt;
}

// Overwrites _write in syscall
int _write(int file, char* ptr, int len) {
    int DataIdx;

    for (DataIdx = 0; DataIdx < len; DataIdx++) {
        usart2_putch(*ptr++);
    }

    return len;
}

// gets a character from the recieve buffer
char usart2_getch(){
    return get(&recieve);
}

// adds a character to the transmit buffer + echo back
void usart2_putch(char c){
    put(&transmit, c);
    // Enable transmit interrupt
    *USART_CR1 |= (1 << TXEIE);
}

void init_usart2(uint32_t baud, uint32_t sysclk) {
    // Enable clocks for GPIOA and USART2
    *(RCC_AHB1ENR) |= (1<<GPIOAEN);
    *(RCC_APB1ENR) |= (1<<USART2EN);

    // Function 7 of PORTA pins is USART
    *(GPIOA_AFRL) &= (0xFFFF00FF); // Clear the bits associated with PA3 and PA2
    *(GPIOA_AFRL) |= (0b01110111<<8);  // Choose function 7 for both PA3 and PA2
    *(GPIOA_MODER) &= (0xFFFFFF0F);  // Clear mode bits for PA3 and PA2
    *(GPIOA_MODER) |= (0b1010<<4);  // Both PA3 and PA2 in alt function mode

    // Enable global interrupt
    *ISER1 |= 1 << USART2_INTERRUPT;

    // Set up USART2
    //USART2_init();  //8n1 no flow control
    // over8 = 0..oversample by 16
    // M = 0..1 start bit, data size is 8, 1 stop bit
    // PCE= 0..Parity check not enabled
    // no interrupts... using polling
    *(USART_CR1) = (1 << UE) | (1 << TE) | (1 << RE) | (1 << RXNEIE); // Enable UART, Tx and Rx
    *(USART_CR2) = 0;  // This is the default, but do it anyway
    *(USART_CR3) = 0;  // This is the default, but do it anyway
    *(USART_BRR) = sysclk / baud;

    /* I'm not sure if this is needed for standard IO*/
     //setvbuf(stderr, NULL, _IONBF, 0);
     //setvbuf(stdin, NULL, _IONBF, 0);
     setvbuf(stdout, NULL, _IONBF, 0);
}

void USART2_IRQHandler(void) {
    // RXNE
    // Add the character to the buffers
    if (*USART_SR & (1<<RXNE)) {
        char c = *USART_DR;
        put(&transmit, c);
        if (c == '\r') {
            usart2_putch('\n');
            c = '\n';
        }
        put(&recieve, c);
    }

    // TXE
    // Echo back to the serial console
    if (*USART_SR & (1<<TXE)) {
        if (has_element(&transmit)) {
            *USART_DR = get(&transmit);
        } else {
            *USART_CR1 &= ~(1 << TXEIE);
        }
    }
}
```
