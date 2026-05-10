#!/usr/bin/env bash
set -euo pipefail

# --- 1. Daftar Artefak yang Wajib Ada ---
required_files=(
    "build/kernel.elf"
    "build/kernel.map"
    "build/inspect/readelf-header.txt"
    "build/inspect/readelf-program-headers.txt"
    "build/inspect/objdump-disassembly.txt"
    "build/inspect/nm-symbols.txt"
    "build/mcsos.iso"
    "build/mcsos.iso.sha256"
    "build/qemu-serial.log"
)

echo "🔍 Memulai audit Milestone 2..."

# --- 2. Cek Keberadaan File ---
for f in "${required_files[@]}"; do
    if [ ! -s "$f" ]; then
        echo "❌ ERROR: Artefak tidak ada atau kosong: $f" >&2
        exit 1
    fi
    echo "✅ OK: Artefak ditemukan: $f"
done

# --- 3. Verifikasi Struktur ELF (Data dari readelf) ---
echo "🔍 Memverifikasi struktur Kernel ELF64..."
grep -q 'Class:.*ELF64' build/inspect/readelf-header.txt || { echo "❌ FAIL: Bukan ELF64"; exit 1; }
grep -q 'Machine:.*Advanced Micro Devices X86-64' build/inspect/readelf-header.txt || { echo "❌ FAIL: Bukan Arsitektur x86-64"; exit 1; }
grep -q 'Entry point address:.*0xffffffff80000000' build/inspect/readelf-header.txt || { echo "❌ FAIL: Alamat Entry Point Salah"; exit 1; }

# --- 4. Verifikasi Output Kernel (Disinkronkan dengan Screenshot 80) ---
echo "🔍 Memverifikasi fungsionalitas Kernel via Serial Log..."
# Catatan: Teks di bawah ini harus sama persis dengan yang ada di kmain.c Anda
grep -q 'MCSOS 260502 - Milestone 2' build/qemu-serial.log || { echo "❌ FAIL: Header Milestone tidak ditemukan"; exit 1; }
grep -q '\[OK\] Early serial online' build/qemu-serial.log || { echo "❌ FAIL: Pesan serial online tidak ditemukan"; exit 1; }
grep -q '\[OK\] Kernel entry path entered' build/qemu-serial.log || { echo "❌ FAIL: Pesan entry path tidak ditemukan"; exit 1; }
grep -q '\[OK\] Reached controlled halt loop' build/qemu-serial.log || { echo "❌ FAIL: Pesan halt loop tidak ditemukan"; exit 1; }

echo "--------------------------------------------------"
echo "🎉 LULUS: Semua verifikasi Milestone 2 BERHASIL!"
echo "--------------------------------------------------"
