/**
  ******************************************************************************
  * @file    main.c
  * @author  John Bretz
  * @version V1.0
  * @brief   Tests that ring buffer functions properly.
  ******************************************************************************
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uart_driver.h"

#define F_CPU 16000000UL

int read_mem(int);
void write_mem(int, int);
void dump_mem(int, int);
void help();
int check_addr(int);

// main
int main()
{
  init_usart2(19200, F_CPU);

  char input[30]; // inputs from the user.
  char cmd[5];
  int address, len, val;

  while (1)
  {

    fgets(input, 30, stdin); // gets input from console.

    /* Handle different commands */
    switch (input[0])
    {
    // Read
    case 'r':
      sscanf(input, "%s %x", cmd, &address); // fetch data from input.
      if (check_addr(address))
      {
        int value = read_mem((uint32_t)address);
        printf("0x%x\n", value);
      }
      break;
    // Write
    case 'w':
      val = 0;
      sscanf(input, "%s %x %x", cmd, &address, &val); // fetch data from input.
      if (check_addr(address))
      {
        write_mem(address, val);
        printf("write 0x%x with 0x%x\n", address, val);
      }
      break;
    // Dump
    case 'd':
      sscanf(input, "%s %x %d", cmd, &address, &len); // fetch data from input.
      // Determine if the length is reasonable.
      if (len > 100 || len < 0)
      {
        len = 16;
      }
      if (check_addr(address))
      {
        dump_mem(address, len);
        printf("\n");
      }
      break;
    // help
    case 'h':
      help();
      break;
    // Invalid selection
    default:
      printf("Unknown command.\n");
      help();
    }
  }

  return 0;
}

int read_mem(int address)
{
  volatile uint32_t *address_pouint32_ter = (uint32_t *)address;
  uint32_t value = *address_pouint32_ter;
  return value;
}

void write_mem(int address, int value)
{
  volatile uint32_t *address_pouint32_ter = (uint32_t *)address;
  *address_pouint32_ter = value;
}

void dump_mem(int address, int length)
{
  volatile uint8_t *address_pointer = (uint8_t *)address;
  for (int i = 0; i < length; i++)
  {
    // determine if the next line is reached.
    if (i % 16 == 0)
    {
      printf("\n0x%x:", (int)address);
      address += 0x10;
    }
    uint8_t byte = address_pointer[i]; // get the current byte.
    printf(" ");
    // handle byte '0'.
    if (byte < 0x10)
    {
      printf("0");
    }
    printf("%x", byte);
  }
}

int check_addr(int address)
{
  uint32_t valid = 1;
  if (address < 0)
  {
    valid = 0;
    printf("The address cannot be negative, and the number might be overflow!\n");
  }
  else if (address % 4 != 0)
  {
    valid = 0;
    printf("The address must be a multiple of 4!\n");
  }
  return valid;
}

void help()
{
  printf("Valid commands are: rm, wm, dm\n");
  printf("\trm: reads from memory {address} | ex: rm 0x20001000\n");
  printf("\twm: write something to memory {address} {value} | ex: wm 0x20001000 0x7\n");
  printf("\tdm: dumps some number of bytes {address} {length} | ex: dm 0x20001000 100\n");
}