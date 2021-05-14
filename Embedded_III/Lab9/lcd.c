//! John Bretz
//! CE2820
//! lcd.c
//! Api impl of LT24 LCD display

#include <stdlib.h>
#include <stdint.h>
#include "system.h"
#include "lcd.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "utils.h"

#define PixelBuffer alt_up_pixel_buffer_dma_dev
#define TOUCH_ENABLE 1

static PixelBuffer *buf = NULL;

static volatile int *TOUCH_CONTROL = (volatile int *)AVALON_TOUCH_0_BASE;
static volatile int *TOUCH_COORDS = (volatile int *)(AVALON_TOUCH_0_BASE + 4);

/// Converts a 24bit color to a 16bit color
static int convert_color(int color)
{
    int R8 = (color >> 16) & 0xFF;
    int G8 = (color >> 8) & 0xFF;
    int B8 = (color >> 0) & 0xFF;

    int R5 = (R8 * 249 + 1014) >> 11;
    int G6 = (G8 * 253 + 505) >> 10;
    int B5 = (B8 * 249 + 1014) >> 11;

    return (R5 << 11) | (G6 << 5) | (B5 << 0);
}

/// Maps an int from 0-0xFFF onto a range from 0-stop2
///
/// @param val: the number to map
/// @param stop2: the max value for the mapping
// static int map(int val, float stop2)
// {
//     float n = (float)val;
//     float stop1 = (float)0xFFF;
//     float out = (n / stop1) * stop2;
//     return (int)out;
// }

void lcd_init(void)
{
    buf = alt_up_pixel_buffer_dma_open_dev(VIDEO_PIXEL_BUFFER_DMA_0_NAME);
    alt_up_pixel_buffer_dma_change_back_buffer_address(buf, (int)malloc(WIDTH * HEIGHT * 2));

    alt_up_pixel_buffer_dma_clear_screen(buf, 0);
    alt_up_pixel_buffer_dma_clear_screen(buf, 1);
}

void lcd_clear(void)
{
    alt_up_pixel_buffer_dma_clear_screen(buf, 0);
    alt_up_pixel_buffer_dma_clear_screen(buf, 1);
}

void lcd_fill(int color)
{
    alt_up_pixel_buffer_dma_draw_box(buf, 0, 0, WIDTH - 1, HEIGHT - 1, convert_color(color), 1);
}

void set_pixel(unsigned int x, unsigned int y, int color)
{
    alt_up_pixel_buffer_dma_draw(buf, convert_color(color), x, y);
}

void draw_line(int x0, int y0, int x1, int y1, int color)
{
    alt_up_pixel_buffer_dma_draw_line(buf, x0, y0, x1, y1, convert_color(color), 1);
}

void draw_rectangle(int x1, int y1, int x2, int y2, int color, bool fill)
{
    if (fill)
    {
        // find smaller value
        int lly = (y1 < y2) ? y1 : y2;
        int height = abs(y2 - y1);

        for (int y = 0; y <= height; y++)
        {
            draw_line(x1, y + lly, x2, y + lly, color);
        }
    }
    else
    {
        draw_line(x1, y1, x2, y1, color);
        draw_line(x1, y1, x1, y2, color);
        draw_line(x2, y1, x2, y2, color);
        draw_line(x1, y2, x2, y2, color);
    }
}

void lcd_present(void)
{
    alt_up_pixel_buffer_dma_swap_buffers(buf);
    while (alt_up_pixel_buffer_dma_check_swap_buffers_status(buf) == 1)
    {
    }
}

void lcd_free(void)
{
    free((int *)buf->back_buffer_start_address);
}

void touch_init(void)
{
    *TOUCH_CONTROL |= TOUCH_ENABLE;
}

void get_touch_data(int32_t storage[2])
{
    storage[0] = WIDTH - map((*TOUCH_COORDS >> 0) & 0xFFF, 0, 0xFFF, 0, (float)WIDTH);
    storage[1] = map((*TOUCH_COORDS >> 16) & 0xFFF, 0, 0xFFF, 0, (float)HEIGHT);
}
