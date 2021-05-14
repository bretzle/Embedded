//! John Bretz
//! CE2820
//! utils.c
//! common util functions

#include <stdint.h>

int32_t map(int32_t n, int32_t start1, int32_t stop1, int32_t start2, int32_t stop2)
{
	int32_t out = (float)(n - start1) / (float)(stop1 - start1) * (float)(stop2 - start2) + (float)start2;
	return out;
}
