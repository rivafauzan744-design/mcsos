#include <stdint.h>

/* Deklarasi fungsi eksternal agar compiler mengenalnya */
void serial_init(void);
void log_init(void);
void kernel_panic_at(const char *file, int line, const char *reason, uint64_t code);

void kmain(void) {
    /* 1. Aktifkan port serial COM1 hardware */
    serial_init();
    
    /* 2. Inisialisasi sistem pencatatan log */
    log_init();
    
    /* 3. Picu Kernel Panic Milestone 3 dengan kode heksadesimal MCSOS03 (0x4d43534f533033) */
    kernel_panic_at(__FILE__, __LINE__, "intentional M3 panic test", 0x4d43534f533033);
}
