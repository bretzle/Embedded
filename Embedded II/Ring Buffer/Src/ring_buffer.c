#include "ring_buffer.h"
#include <stdio.h>

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