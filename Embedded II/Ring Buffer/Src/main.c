/**
  ******************************************************************************
  * @file    main.c
  * @author  Auto-generated by STM32CubeIDE
  * @version V1.0
  * @brief   Default main function.
  ******************************************************************************
*/

#include "ring_buffer.h"

// main
int main() {
    RingBuffer buffer = {0,0,0};

    char byte;

    put(&buffer, 'a');
    put(&buffer, 'b');
    put(&buffer, 'c');
    // put(&buffer, 'd');

    byte = get(&buffer);
    byte = get(&buffer);
    byte = get(&buffer);
    byte = get(&buffer);

    while(1);
}
