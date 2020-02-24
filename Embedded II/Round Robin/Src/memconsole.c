/**
  ******************************************************************************
  * @file    console.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Contains memory functions used by the console.
  ******************************************************************************
*/

#include "stdio.h"

/**
 * Gets a value from memory
 * 
 * @param address the address to read from
 * @returns the value of memory at address
 */
int read_mem(int address) {
    volatile int *ptr = (int *)address;
    int value = *ptr;
    return value;
}

/**
 * Writes some value to a location in memory
 * 
 * @param address the location to write to
 * @param value the value to write
 */
void write_mem(int address, int value) {
    volatile int *address_pouint32_ter = (int *)address;
    *address_pouint32_ter = value;
}

/**
 * Dumps some length of memory to stdout
 * 
 * @param address the address to start the dump
 * @param length the number of bytes to dump
 */
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

/**
 * Checks if a number is a valid memory address
 * 
 * @param address the address to check
 * @returns 1 if address is valid else 0
 */
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

void help(void) {
    printf("Valid commands are:\n");
    printf("\trm: reads from memory {address} | ex: rm 0x20001000\n");
    printf("\twm: write something to memory {address} {value} | ex: wm 0x20001000 0x7\n");
    printf("\tdm: dumps some number of bytes {address} {length} | ex: dm 0x20001000 100\n");
    printf("\tplay: plays Imperial March\n");
    printf("\tpause: pauses the song\n");
    printf("\tresume: resumes the song\n");
    printf("\treplay: restarts the song\n");
}

/**
 * Helper function to determine if a string starts with some substring
 * 
 * @param string the string
 * @param prefix the substring
 * @returns 1 if string starts with prefix else 0
 */
int starts_with(const char* string, const char* prefix) {
    while(*prefix) {
        if (*prefix++ != *string++)
            return 0;
    }

    return 1;
}