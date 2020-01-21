#include "ring_buffer.h"

#define ARRAY_LENGTH(array) sizeof(array)/sizeof(array[0])

void put(RingBuffer * ring, char byte) {
    while (has_space(ring)) {
        (*ring).buffer[(*ring).put] = byte;

        if ((*ring).put == ARRAY_LENGTH((*ring).buffer) - 1) {
            (*ring).put = 0;
        } else {
            (*ring).put += 1;
        }
    }
}

char get(RingBuffer * ring) {
    char value;

    while (has_space(ring)) {
        value = (*ring).buffer[(*ring).get];
        if ((*ring).get == ARRAY_LENGTH((*ring).buffer) - 1) {
            (*ring).get = 0;
        } else {
            (*ring).get += 1;
        }
    }

    return value;
}

// todo
int has_space(RingBuffer * ring) {
	return 1;
}

// todo
int has_element(RingBuffer * ring) {
	return 1;
}
