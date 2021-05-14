//! John Bretz
//! CE2820-
//! seven_seg.c
//! API for Seven Segment Display
//!
//! Depends on `seven_seg.h`

#include "seven_seg.h"
#include <system.h>
#include <assert.h>
#include <stdio.h>

int *HEX_DECODER = (volatile int *)HEXER_BASE;

int write_hex_display(int num, int base)
{
  assert(base == 10 || base == 16);

  char str[7];
  if (base == 10)
  {
    if (sprintf(str, "%06d", num) == -1)
    {
      return -1;
    }
  }
  else
  {
    if (sprintf(str, "%06x", num) == -1)
    {
      return -1;
    }
  }

  char *c = str;
  int digit = 5;
  int written = 0;

  // skip leading zeros
  while (*c && *c == '0' && digit != 0)
  {
    clear_hex(digit);
    c++;
    digit--;
  }

  for (int i = digit; i >= 0; i--)
  {
    char cc = *c;
    if (cc >= '0' && cc <= '9')
    {
      cc -= 48;
    }
    else if (cc >= 'a' && cc <= 'f')
    {
      cc -= 87;
    }
    write_hex(cc, i);
    written++;
    c++;
  }

  return written;
}

void clear_hex_display(void)
{
  *HEX_DECODER = 0;
}

void write_hex(char c, int block)
{
  int shift = block * 5;
  int data = (((int)c << 1) | 0x1);

  int val = *HEX_DECODER; // RMW
  val &= ~(0x1F << shift);
  val |= data << shift;
  *HEX_DECODER = val;
}

void clear_hex(int block)
{
  int shift = block * 5;

  int val = *HEX_DECODER; // RMW
  val &= ~(0x1F << shift);
  *HEX_DECODER = val;
}
