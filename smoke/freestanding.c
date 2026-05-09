#include <stdint.h>
#include <stddef.h>

/**
 * MCSOS_M0_MAGIC: Penanda unik "MCS0" dalam format Little Endian.
 */
#define MCSOS_M0_MAGIC 0x4D435330u 

struct m0_smoke_record {
    uint32_t magic;
    uint32_t version;
    uintptr_t pointer_width;
    size_t size_width;
};

/* 
 * __attribute__((used)) memastikan compiler tidak menghapus struct ini 
 * meskipun tidak dipanggil secara eksplisit di dalam kode, sehingga 
 * metadata tetap ada di dalam object file atau binary hasil build.
 */
__attribute__((used))
const struct m0_smoke_record m0_smoke_record = {
    .magic          = MCSOS_M0_MAGIC,
    .version        = 260502u,
    .pointer_width  = sizeof(void *),
    .size_width     = sizeof(size_t),
};

/**
 * Fungsi sederhana untuk memverifikasi kemampuan aritmatika dasar
 * pada lingkungan freestanding.
 */
int m0_smoke_add(int a, int b) {
    return a + b;
}
