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

#endif