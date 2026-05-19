#include <mcsos/kernel/log.h>
#include <mcsos/kernel/panic.h>

void kmain(void) {
    log_init();
    
    // Memicu panic sesuai format instruksi M3 halaman 23:
    // "intentional M3 panic test" dengan kode 0x4d43534f533033
    kernel_panic_at("kernel/core/kmain.c", 20, "intentional M3 panic test", 0x4d43534f533033);
}
