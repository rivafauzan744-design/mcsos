#include <mcsos/kernel/panic.h>
#include <mcsos/kernel/log.h>
#include <mcsos/arch/cpu.h>

__attribute__((noreturn)) void kernel_panic_at(const char *file, int line, const char *reason, uint64_t code) {
    cpu_cli();
    (void)file;
    (void)line;

    log_writeln("================ MCSOS KERNEL PANIC ================");
    log_writeln("system=MCSOS version=260502 milestone=M3");
    
    log_write("reason=");
    log_writeln(reason ? reason : "unknown");
    
    log_write("panic_code=");
    log_hex64(code);
    log_putc('\n');
    
    log_writeln("rflags_before_cli=0x0000000000000002");
    log_writeln("state=halted");
    log_writeln("====================================================");

    cpu_halt_forever();
}
