/**
  ******************************************************************************
  * @file    ring_buffer.h
  * @author  John Bretz
  * @version V1.0
  * @brief   Prototypes for a Ring Buffer.
  ******************************************************************************
*/

#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#define BUFFER_SIZE 25

typedef struct {
    int put;
    int get;
    int amount;
    char buffer[BUFFER_SIZE];
} RingBuffer;

// returns true if their is room for at least one element in the buffer
int has_space(RingBuffer *);

// returns true if their is at least one room in the buffer
int has_element(RingBuffer *);

// Will try to add an element into the buffer
// Will return non-zero if element added else zero
void put(RingBuffer *, char);

// Will try to get an element from the buffer
// Will return the element if retrieved else -1
char get(RingBuffer *);

// Prints `put`, `get`, `amount` to stdout for debugging purposes
void print(RingBuffer *);

#endif