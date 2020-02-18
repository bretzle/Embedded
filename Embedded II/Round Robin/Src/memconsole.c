#include "stdio.h"

int read_mem(int address) {
    volatile int *address_pouint32_ter = (int *)address;
    int value = *address_pouint32_ter;
    return value;
}

void write_mem(int address, int value) {
    volatile int *address_pouint32_ter = (int *)address;
    *address_pouint32_ter = value;
}

void dump_mem(int address, int length) {
    volatile char *address_pointer = (char *)address;
    for (int i = 0; i < length; i++) {
        // determine if the next line is reached.
        if (i % 16 == 0) {
            printf("\n0x%x:", (int)address);
            address += 0x10;
        }
        char byte = address_pointer[i]; // get the current byte.
        printf(" ");
        // handle byte '0'.
        if (byte < 0x10) {
            printf("0");
        }
        printf("%x", byte);
    }
}

int check_addr(int address) {
    int valid = 1;
    if (address < 0) {
        valid = 0;
        printf("The address cannot be negative, and the number might be overflow!\n");
    }
    else if (address % 4 != 0) {
        valid = 0;
        printf("The address must be a multiple of 4!\n");
    }
    return valid;
}

void help() {
    printf("Valid commands are: rm, wm, dm\n");
    printf("\trm: reads from memory {address} | ex: rm 0x20001000\n");
    printf("\twm: write something to memory {address} {value} | ex: wm 0x20001000 0x7\n");
    printf("\tdm: dumps some number of bytes {address} {length} | ex: dm 0x20001000 100\n");
}