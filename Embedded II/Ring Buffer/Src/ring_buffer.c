#include "ring_buffer.h"

#define ARRAY_LENGTH(array) sizeof(array)/sizeof(array[0])

void put(RingBuffer * ring, char byte) {
    while (1) {
        if (has_space(ring)) {
            (*ring).buffer[(*ring).put] = byte;
            (*ring).amount += 1;

            if ((*ring).put == ARRAY_LENGTH((*ring).buffer) - 1) {
                (*ring).put = 0;
            } else {
                (*ring).put += 1;
            }   
            return;    
        }
    }
}

char get(RingBuffer * ring) {
    char value;

    while (1) {
        if (has_element(ring)) {
            value = (*ring).buffer[(*ring).get];
            (*ring).amount -= 1;

            if ((*ring).get == ARRAY_LENGTH((*ring).buffer) - 1) {
                (*ring).get = 0;
            } else {
                (*ring).get += 1;
            }

            return value;
        }
    }
}

int has_space(RingBuffer * ring) {
	return (*ring).amount < ARRAY_LENGTH((*ring).buffer);
}

int has_element(RingBuffer * ring) {
	return (*ring).amount > 0;
}
