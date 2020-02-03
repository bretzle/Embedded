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
    if (has_space(buffer)) {
        buffer->buffer[buffer->put] = element;
        buffer->put++;
        if (buffer->put > BUFFER_SIZE - 1) {
            buffer->put = 0;
        }
    }
}

char get(RingBuffer * ring) {
    char element;
    if (has_element(ring)) {
        element = ring->buffer[ring->get];
        ring->get++;
        if (ring->get > BUFFER_SIZE - 1) {
        	ring->get = 0;
        }
    } else {
    	element = -1;
    }

    return element;
}

int has_space(RingBuffer* buffer) {
    int hasSpace;
    if ((buffer->get - buffer->put) == 1 || (buffer->put == BUFFER_SIZE - 1 && buffer->get == 0)) {
        hasSpace = 0;
    } else {
        hasSpace = 1;
    }
    return hasSpace;
}

int has_element(RingBuffer* buffer) {
    int hasElement;
    if ((buffer->put - buffer->get) == 0) {
        hasElement = 0;
    } else {
        hasElement = 1;
    }
    return hasElement;
}

void print(RingBuffer * ring) {
   printf("\tPut: %d\n", (*ring).put);
   printf("\tGet: %d\n", (*ring).get);
//   printf("\tSize: %d\n", (*ring).amount);
}
