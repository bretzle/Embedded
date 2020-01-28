```c
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
```

```c
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

#define BUFFER_SIZE 3

typedef struct {
    int put;
    int get;
    int amount;
    char buffer[BUFFER_SIZE];
} RingBuffer;

// Puts a new character into the buffer
// Will block until their is space to fit a new element
void put_b(RingBuffer *, char);

// Gets the next character from the buffer
// Will block if the buffer is empty
char get_b(RingBuffer *);

// returns true if their is room for at least one element in the buffer
int has_space(RingBuffer *);

// returns true if their is at least one room in the buffer
int has_element(RingBuffer *);

// Will try to add an element into the buffer
// Will return non-zero if element added else zero
char put(RingBuffer *, char);

// Will try to get an element from the buffer
// Will return the element if retrieved else -1
char get(RingBuffer *);

// Prints `put`, `get`, `amount` to stdout for debugging purposes
void print(RingBuffer *);

#endif
```

```c
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

// Macro to calculate the length of an array
#define ARRAY_LENGTH(array) sizeof(array)/sizeof(array[0])

void put_b(RingBuffer * ring, char byte) {
    while (1) {
        if (put(ring, byte)) {
            return;
        }
    }
}

char put(RingBuffer * ring, char byte) {
    if (has_space(ring)) {
        (*ring).buffer[(*ring).put] = byte;
        (*ring).amount += 1;

        if ((*ring).put == ARRAY_LENGTH((*ring).buffer) - 1) {
            (*ring).put = 0;
        } else {
            (*ring).put += 1;
        }   

        return 1;
    }
    return 0;
}

char get_b(RingBuffer * ring) {
    char value;

    while (1) {
        value = get(ring);
        if (value != -1) {
            return value;
        }
    }
}

char get(RingBuffer * ring) {
    if (has_element(ring)) {
        char value = (*ring).buffer[(*ring).get];
        (*ring).amount -= 1;

        if ((*ring).get == ARRAY_LENGTH((*ring).buffer) - 1) {
            (*ring).get = 0;
        } else {
            (*ring).get += 1;
        }

        return value;
    }

    return -1;
}

int has_space(RingBuffer * ring) {
    return (*ring).amount < ARRAY_LENGTH((*ring).buffer);
}

int has_element(RingBuffer * ring) {
    return (*ring).amount > 0;
}

void print(RingBuffer * ring) {
   printf("\tPut: %d\n", (*ring).put);
   printf("\tGet: %d\n", (*ring).get);
   printf("\tSize: %d\n", (*ring).amount); 
}
```
