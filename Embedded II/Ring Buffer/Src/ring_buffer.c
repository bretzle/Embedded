#include "ring_buffer.h"

#define ARRAY_LENGTH(array) sizeof(array)/sizeof(array[0])

void put(RingBuffer * ring, char byte) {
    RingBuffer buffer = *ring;
    
    (*ring).buffer[buffer.put] = byte;

    if (buffer.put == ARRAY_LENGTH(buffer.buffer) - 1) {
        (*ring).put = 0;
    } else {
        (*ring).put += 1;
    }
}

char get(RingBuffer * ring) {
    RingBuffer buffer = *ring;

    int value = buffer.buffer[buffer.get];

    if (buffer.get == ARRAY_LENGTH(buffer.buffer) - 1) {
        (*ring).get = 0;
    } else {
        (*ring).get += 1;
    }

    return value;
}

int has_space(RingBuffer * ring) {
	return 0;
}

int has_element(RingBuffer * ring) {
	return 0;
}
