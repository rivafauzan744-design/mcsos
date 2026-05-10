#include <stdint.h>
#include <stddef.h>
#include <mcsos/arch/io.h>

/* Alamat standar Port COM1 */
#define COM1_PORT 0x3F8u

/**
 * Memeriksa apakah buffer pengiriman (Transmit Holding Register) kosong.
 * Register status ada di (Port + 5). Bit 5 (0x20) menandakan siap kirim.
 */
static int serial_transmit_empty(void) {
    return (inb((uint16_t)(COM1_PORT + 5u)) & 0x20u) != 0;
}

/**
 * Inisialisasi Port Serial COM1.
 * Mengatur baud rate, parity, dan mode pengiriman data.
 */
void serial_init(void) {
    outb((uint16_t)(COM1_PORT + 1u), 0x00u); // Matikan interrupt
    outb((uint16_t)(COM1_PORT + 3u), 0x80u); // Aktifkan DLAB (Baud rate divisor)
    outb((uint16_t)(COM1_PORT + 0u), 0x03u); // Set divisor ke 3 (38400 baud)
    outb((uint16_t)(COM1_PORT + 1u), 0x00u); // (High byte divisor)
    outb((uint16_t)(COM1_PORT + 3u), 0x03u); // 8 bits, no parity, one stop bit
    outb((uint16_t)(COM1_PORT + 2u), 0xC7u); // FIFO, clear, 14-byte threshold
    outb((uint16_t)(COM1_PORT + 4u), 0x0Bu); // IRQs enabled, RTS/DSR set
}

/**
 * Mengirim satu karakter ke port serial.
 * Otomatis menambahkan Carriage Return (\r) sebelum Newline (\n).
 */
void serial_putc(char c) {
    if (c == '\n') {
        serial_putc('\r');
    }
    
    /* Tunggu sampai register pengiriman kosong */
    while (!serial_transmit_empty()) {
        io_wait();
    }
    
    outb((uint16_t)COM1_PORT, (uint8_t)c);
}

/**
 * Mengirim string (kumpulan karakter) ke port serial.
 */
void serial_write(const char *s) {
    if (s == NULL) {
        return;
    }
    
    while (*s != '\0') {
        serial_putc(*s++);
    }
}
