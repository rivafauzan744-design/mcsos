#include <stdint.h>
#include <serial.h>

void kmain(void) {
    serial_init();
    
    serial_write("MCSOS 260502 - Milestone 2\n");
    serial_write("[OK] Early serial online\n");
    serial_write("[OK] Kernel entry path entered\n");
    serial_write("[OK] Reached controlled halt loop\n");

    while (1) {
        __asm__ volatile ("hlt");
    }
}
