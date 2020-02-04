
#ifndef _MUSIC_H
#define _MUSIC_H

#define BPM 120
#define QUARTER 60000/BPM

typedef struct {
    int freq;
    int len;
} NOTE;

#define NOTE_A3 {1, QUARTER}
#define NOTE_F3 {2, QUARTER}
#define NOTE_C4 {3, QUARTER}

#define NOTE_END {0, 0}

#endif