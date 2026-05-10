#ifndef MCSOS_ARCH_IO_H
#define MCSOS_ARCH_IO_H

#include <stdint.h>

/**
 * Mengirim 1 byte data ke I/O port tertentu.
 */
static inline void outb(uint16_t port, uint8_t value) {
    __asm__ volatile (
        "outb %0, %1" 
        : 
        : "a"(value), "Nd"(port) 
        : "memory"
    );
}

/**
 * Membaca 1 byte data dari I/O port tertentu.
 */
static inline uint8_t inb(uint16_t port) {
    uint8_t value;
    __asm__ volatile (
        "inb %1, %0" 
        : "=a"(value) 
        : "Nd"(port) 
        : "memory"
    );
    return value;
}

/**
 * Memberikan jeda singkat pada operasi I/O.
 * Berguna untuk perangkat lama yang lambat merespons.
 */
static inline void io_wait(void) {
    outb(0x80, 0);
}

#endif /* MCSOS_ARCH_IO_H */
