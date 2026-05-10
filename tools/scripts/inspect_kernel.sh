#!/usr/bin/env bash
set -euo pipefail

# 1. Konfigurasi Path
KERNEL="build/kernel.elf"
OUT="build/inspect"
mkdir -p "$OUT"

# Pastikan kernel sudah di-build
if [ ! -f "$KERNEL" ]; then
    echo "❌ ERROR: File $KERNEL tidak ditemukan. Jalankan 'make build' terlebih dahulu."
    exit 1
fi

echo "🔍 Memulai inspeksi mendalam kernel..."

# 2. Ekstraksi Metadata Binary
readelf -hW "$KERNEL" | tee "$OUT/readelf-header.txt"
readelf -lW "$KERNEL" | tee "$OUT/readelf-program-headers.txt"
readelf -SW "$KERNEL" | tee "$OUT/readelf-sections.txt" >/dev/null
objdump -drwC "$KERNEL" | tee "$OUT/objdump-disassembly.txt" >/dev/null
nm -n "$KERNEL" | tee "$OUT/nm-symbols.txt" >/dev/null

# 3. Validasi Invarian Kernel (Automated Checks)
echo "----------------------------------------"
echo "Validating invariants..."

# Cek apakah formatnya ELF64
grep -q 'Class:.*ELF64' "$OUT/readelf-header.txt" || \
    { echo "❌ FAILED: Bukan format ELF64"; exit 1; }

# Cek apakah arsitekturnya x86-64
grep -q 'Machine:.*Advanced Micro Devices X86-64' "$OUT/readelf-header.txt" || \
    { echo "❌ FAILED: Arsitektur bukan x86-64"; exit 1; }

# Cek apakah Entry Point sudah benar di Higher Half
grep -q 'Entry point address:.*0xffffffff80000000' "$OUT/readelf-header.txt" || \
    { echo "❌ FAILED: Entry point salah (Harus 0xffffffff80000000)"; exit 1; }

# Cek keberadaan simbol-simbol vital
grep -q 'kmain' "$OUT/nm-symbols.txt" || { echo "❌ FAILED: Simbol kmain hilang"; exit 1; }
grep -q 'serial_init' "$OUT/nm-symbols.txt" || { echo "❌ FAILED: Simbol serial_init hilang"; exit 1; }
grep -q 'serial_write' "$OUT/nm-symbols.txt" || { echo "❌ FAILED: Simbol serial_write hilang"; exit 1; }

echo "✅ OK: Semua inspeksi ELF kernel berhasil dilewati!"
echo "----------------------------------------"
