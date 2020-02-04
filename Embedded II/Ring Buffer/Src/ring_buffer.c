/**
  ******************************************************************************
  * @file    ring_buffer.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Implementation of a Ring Buffer.
  ******************************************************************************
*/

#include "ring_buffer.h"
#include <stdio.h>

void put(RingBuffer* buffer, char element) {
    while (!has_space(buffer));

    buffer->buffer[buffer->put] = element;

    if (buffer->put >= BUFFER_SIZE) {
        buffer->put = 0;
    } else {
        buffer->put++;
    }

    buffer->amount++;
}

char get(RingBuffer* buffer) {
    while (!has_element(buffer));

    char element = buffer->buffer[buffer->get];

    if (buffer->get >= BUFFER_SIZE) {
        buffer->get = 0;
    } else {
        buffer->get++;
    }

    buffer->amount--;
    return element;
}

int has_space(RingBuffer* buffer) {
    return BUFFER_SIZE != buffer->amount;
}

int has_element(RingBuffer* buffer) {
    return buffer->amount > 0;
}
