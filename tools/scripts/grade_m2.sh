#!/usr/bin/env bash
set -euo pipefail

# Daftar file yang harus ada sebelum dikumpulkan
required_files=(
    build/kernel.elf
    build/kernel.map
    build/inspect/readelf-header.txt
    build/inspect/readelf-program-headers.txt
    build/inspect/objdump-disassembly.txt
    build/inspect/nm-symbols.txt
    build/mcsos.iso
    build/mcsos.iso.sha256
    build/qemu-serial.log
)

echo "--- Memeriksa Artefak ---"
for f in "${required_files[@]}"; do
    if [ ! -s "$f" ]; then
        echo "ERROR: artefak tidak ada atau kosong: $f" >&2
        exit 1
    fi
    echo "OK: $f ditemukan."
done

echo -e "\n--- Memeriksa Header ELF ---"
grep -q 'Class:.*ELF64' build/inspect/readelf-header.txt
grep -q 'Machine:.*Advanced Micro Devices X86-64' build/inspect/readelf-header.txt
grep -q 'Entry point address:.*0xffffffff80000000' build/inspect/readelf-header.txt
echo "OK: Header ELF valid (x86_64, 64-bit)."

echo -e "\n--- Memeriksa Log Booting ---"
# Penyesuaian kata kunci agar sesuai dengan output kernel kamu:
grep -q 'MCSOS 260502' build/qemu-serial.log
grep -q 'Early serial online' build/qemu-serial.log
grep -q 'Reached controlled halt loop' build/qemu-serial.log

echo "OK: Log booting valid."
echo -e "\n=========================================="
echo "HASIL: M2 local grading checks passed!"
echo "=========================================="
