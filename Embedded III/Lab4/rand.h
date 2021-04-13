//! John Bretz
//! CE2820
//! rand.h
//! Api for random numbers
//!
//! Uses a basic XorShift algorithm to generate random numbers
//! See https://en.wikipedia.org/wiki/Xorshift for more info
//!
//! This is used instead of stdlib's `rand()` as the max value did
//! not cover the color span used by the LCD

#ifndef RAND_H_
#define RAND_H_

/// Holds the current state for the random number generator
typedef struct Rand
{
	unsigned int state;
} Rand;

/// Generates a random integer
int gen_rand(struct Rand* rand)
{
	unsigned int x = rand->state;
	x ^= x << 13;
	x ^= x >> 7;
	x ^= x << 17;
	return rand->state = x;
}

#endif /* RAND_H_ */
