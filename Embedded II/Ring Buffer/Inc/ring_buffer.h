#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#define BUFFER_SIZE 3

typedef struct {
    int put;
    int get;
    char buffer[BUFFER_SIZE];
} RingBuffer;

void put(RingBuffer *, char);
char get(RingBuffer *);
int has_space(RingBuffer *);
int has_element(RingBuffer *);

#endif