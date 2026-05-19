#include <mcsos/arch/io.h>
#include <stdint.h>

#define COM1_PORT 0x3F8

void serial_init(void) {
    outb(0x3F8 + 1, 0x00);    // Disable semua interrupts
    outb(0x3F8 + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(0x3F8 + 0, 0x03);    // Set divisor ke 3 (38400 baud)
    outb(0x3F8 + 1, 0x00);    // High byte divisor
    outb(0x3F8 + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(0x3F8 + 2, 0xC7);    // Enable FIFO, clear dengan 14-byte threshold
    outb(0x3F8 + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

void serial_putc(char c) {
    while ((inb(0x3F8 + 5) & 0x20) == 0);

    outb(0x3F8, c);
}
