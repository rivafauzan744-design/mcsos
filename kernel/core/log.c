#include <mcsos/kernel/log.h>

// Deklarasi fungsi eksternal dari driver serial
void serial_init(void);
void serial_putchar(char c);

void log_init(void) {
    serial_init();
}

void log_putc(char c) {
    if (c == '\n') {
        serial_putchar('\r');
    }
    serial_putchar(c);
}

void log_write(const char *str) {
    if (!str) return;
    while (*str) {
        log_putc(*str++);
    }
}

void log_writeln(const char *str) {
    log_write(str);
    log_putc('\n');
}

void log_hex64(uint64_t val) {
    char hex_chars[] = "0123456789abcdef";
    log_write("0x");
    for (int i = 60; i >= 0; i -= 4) {
        log_putc(hex_chars[(val >> i) & 0xF]);
    }
}
