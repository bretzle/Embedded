//! John Bretz
//! CE2820-
//! seven_seg.c
//! API for Seven Segment Display

/// Each seven segement cell is 8 bits where each bit
/// controls a segement. The following layout is used
/// 
///    Hex layout
///
///    /---0---\
///    |       |
///    5       1
///    |       |
///     ---6---
///    |       |
///    4       2
///    |       |
///    \---3---/  7.

#include "seven_seg.h"
#include <system.h>
#include <assert.h>
#include <stdio.h>

int *HEX30 = (int *) HEX3_HEX0_BASE;
int *HEX54 = (int *) HEX5_HEX4_BASE;

int write_hex_display(int num)
{
  char str[6];
  if (sprintf(str, "%06d", num) == -1)
  {
    return -1;
  }

  char *c = str;
  int digit = 5;
  int written = 0;

  // skip leading zeros
  while (*c && *c == '0' && digit != 0)
  {
    c++;
    digit--;
  }

  for (int i = digit; i >= 0; i--)
  {
    write_hex(*c, i);
    written++;
    c++;
  }

  return written;
}

void clear_hex_display(void)
{
  *HEX30 = 0;
  *HEX54 = *HEX54 & 0xFFFF0000;
}

void write_hex(char c, int block)
{
  // bounds check
  assert(block >= 0);
  assert(block <= 5);
  assert(c >= '0');
  assert(c <= '9');

  int data;

  // convert ascii to seg-display
  switch (c)
  {
  case '0':
    data = 0b00111111;
    break;
  case '1':
    data = 0b00000110;
    break;
  case '2':
    data = 0b01011011;
    break;
  case '3':
    data = 0b01001111;
    break;
  case '4':
    data = 0b01100110;
    break;
  case '5':
    data = 0b01101101;
    break;
  case '6':
    data = 0b01111101;
    break;
  case '7':
    data = 0b00000111;
    break;
  case '8':
    data = 0b01111111;
    break;
  case '9':
    data = 0b01101111;
    break;
  default:
    break;
  }

  // write to display
  if (block >= 0 || block <= 3)
  {
    *HEX30 = data << (block * 8);
  }
  else if (block >= 4 || block <= 5)
  {
    *HEX54 = data << ((block - 4) * 8);
  }
}
