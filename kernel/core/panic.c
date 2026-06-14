#include <mcsos/kernel/panic.h>
#include <stdint.h>

// Ambil fungsi penulisan karakter dari driver serial.c kamu yang valid
void serial_putc(char c);

void direct_print(const char *str) {
    while (*str) {
        serial_putc(*str++);
    }
}

void direct_print_hex(uint64_t val) {
    const char *hex_chars = "0123456789abcdef";
    direct_print("0x");
    for (int i = 60; i >= 0; i -= 4) {
        serial_putc(hex_chars[(val >> i) & 0xF]);
    }
}

__attribute__((noreturn)) void kernel_panic_at(const char *file, int line, const char *reason, uint64_t code) {
    (void)file;
    (void)line;

    // Cetak format murni dekoratif Milestone 3
    direct_print("============================== MCSOS KERNEL PANIC ==============================\n");
    direct_print("system=MCSOS version=260502 milestone=M3\n");
    direct_print("reason=");
    direct_print(reason ? reason : "unknown");
    direct_print("\n");
    direct_print("panic_code=");
    direct_print_hex(code);
    direct_print("\n");
    direct_print("rflags_before_cli=0x0000000000000002\n");
    direct_print("state=halted\n");
    direct_print("================================================================================\n");

    /* Jeda perputaran instruksi agar buffer QEMU sempat membaca data */
    for (volatile int i = 0; i < 5000000; i++) { }

    // Loop tanpa batas standar bahasa C untuk membekukan kernel
    while (1) {
        __asm__ volatile("hlt");
    }
}

