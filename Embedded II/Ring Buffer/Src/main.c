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

// main
int main() {

    init_usart2(19200, 16000000);

    RingBuffer buffer = {0,0,0};

    char byte;

    // Put should be 2
    // Size should be 2
    printf("Adding 2 elements.\n");
    put(&buffer, 'a');
    put(&buffer, 'b');
    print(&buffer);

    // Put should loop back to 0
    // Size should be 3
    printf("Adding one more\n");
    put(&buffer, 'c');
    print(&buffer);

    // Get should loop back to 0
    // Size should be 0
    printf("Reading buffer 3 times\n");
    byte = get(&buffer);
    byte = get(&buffer);
    byte = get(&buffer);
    print(&buffer);

    // byte should be -1 or 255
    printf("Try to read when empty\n");
    byte = get(&buffer);
    printf("%d\n", byte);

    while(1);
}
