#include <stddef.h>
#include <stdint.h>

/**
 * Mengisi blok memori dengan nilai byte tertentu.
 * Biasanya digunakan untuk membersihkan (zeroing) struktur data.
 */
void *memset(void *dest, int value, size_t count) {
    unsigned char *d = (unsigned char *)dest;
    while (count-- != 0u) {
        *d++ = (unsigned char)value;
    }
    return dest;
}

/**
 * Menyalin blok memori dari sumber ke tujuan.
 * PENTING: Dest dan Src tidak boleh tumpang tindih (overlap).
 */
void *memcpy(void *dest, const void *src, size_t count) {
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;
    while (count-- != 0u) {
        *d++ = *s++;
    }
    return dest;
}

/**
 * Menyalin blok memori dengan aman meskipun terjadi tumpang tindih (overlap).
 * Fungsi ini mendeteksi arah penyalinan untuk mencegah data tertimpa sebelum disalin.
 */
void *memmove(void *dest, const void *src, size_t count) {
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;

    if (d == s || count == 0u) {
        return dest;
    }

    if (d < s) {
        /* Penyalinan maju (Forward copy) */
        while (count-- != 0u) {
            *d++ = *s++;
        }
    } else {
        /* Penyalinan mundur (Backward copy) untuk menangani overlap */
        d += count;
        s += count;
        while (count-- != 0u) {
            *--d = *--s;
        }
    }
    return dest;
}
