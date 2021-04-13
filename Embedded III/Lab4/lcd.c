//! John Bretz
//! CE2820
//! lcd.c
//! Api impl of LT24 LCD display

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "lcd.h"

volatile int *LCD_BASE = (volatile int *)EXPANSION_JP1_BASE;
volatile int *LCD_DIRECTION_BASE = (volatile int *)(EXPANSION_JP1_BASE+4);

// bitflags
#define WR_N (1 << 17)
#define RS (1 << 18)
#define RD_N (1 << 16)
#define CS_N (1 << 19)
#define RESET_N (1 << 20)
#define LCD_ON (1 << 21)
#define CMDDATMASK (CS_N | RD_N | RS | WR_N | 0x0000FFFF)

// init commands
#define COLMOD_CMD 0x3A
#define MEMCTL_CMD 0x36
#define SLPOUT_CMD 0x11
#define DISPON_CMD 0x29

// draw commands
#define COL_ADDR_SET_CMD  0x2A
#define PAGE_ADDR_SET_CMD 0x2B
#define MEM_WR_CMD        0x2C

/// Sends a command to the LCD
static void lcd_cmd(int cmd)
{
  int val = *LCD_BASE;
  val &= ~CMDDATMASK;
  val |= cmd & 0xFFFF;
  val |= RD_N;

  *LCD_BASE = val;

  val |= WR_N;

  *LCD_BASE = val;
}

/// Sends data to the LCD
static void lcd_data(int data)
{
  int val = *LCD_BASE;
  val &= ~CMDDATMASK;
  val |= data & 0xFFFF;
  val |= (RS | RD_N);

  *LCD_BASE = val;

  val |= WR_N;

  *LCD_BASE = val;
}

/// Sets the window on the LCD
static void lcd_set_window(unsigned int xleft, unsigned int ytop, unsigned int width, unsigned int height)
{
  unsigned int xright = xleft + width - 1;
  unsigned int ybottom = ytop + height - 1;

  //Define the left and right of the display
  lcd_cmd(COL_ADDR_SET_CMD);
  lcd_data((xleft >> 8) & 0xFF);
  lcd_data(xleft & 0xFF);
  lcd_data((xright >> 8) & 0xFF);
  lcd_data(xright & 0xFF);

  //Define the top and bottom of the display
  lcd_cmd(PAGE_ADDR_SET_CMD);
  lcd_data((ytop >> 8) & 0xFF);
  lcd_data(ytop & 0xFF);
  lcd_data((ybottom >> 8) & 0xFF);
  lcd_data(ybottom & 0xFF);

  //Create window and prepare for data
  lcd_cmd(MEM_WR_CMD);
}

void lcd_init(void)
{
  // setup direction of gpio pins
  // Outputs are 1, inputs are 0
  *LCD_DIRECTION_BASE = 0x383FFFFF;

  // setup pins
  int base = *LCD_BASE;
  base &= ~(CMDDATMASK | LCD_ON | RESET_N);
  base |= (CS_N | WR_N | RD_N);
  *LCD_BASE = base;

  // turn on and wait for 120 ms
  base = *LCD_BASE;
  base |= (RESET_N | LCD_ON);
  *LCD_BASE = base;
  usleep(120000);

  // issue commands

  lcd_cmd(COLMOD_CMD);
  lcd_data(0x5);

  lcd_cmd(MEMCTL_CMD);
  lcd_data(0xE8);

  lcd_cmd(SLPOUT_CMD);
  usleep(5000);

  lcd_cmd(DISPON_CMD);

  // clear screen
  lcd_fill(WHITE);
}

void lcd_fill(short color)
{
  lcd_set_window(0, 0, LCD_WIDTH, LCD_HEIGHT);

  for (int i = 0; i < (LCD_WIDTH * LCD_HEIGHT); i++)
  {
    lcd_data(color);
  }
}

void lcd_set_pixel(unsigned int x, unsigned int y, short color)
{
  lcd_set_window(x, y, 1, 1);
  lcd_data(color);
}

short convert_color(unsigned int r, unsigned int g, unsigned int b)
{
  // clamp components
  if (r > 0x1F)
    r = 0x1F;
  if (g > 0x3F)
    g = 0x3F;
  if (b > 0x1F)
    b = 0x1F;

  short val = (r << 11) + (g << 5) + (b << 0);

  return val;
}
