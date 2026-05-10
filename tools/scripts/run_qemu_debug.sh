#!/usr/bin/env bash
set -euo pipefail

# 1. Konfigurasi Path
ISO="build/mcsos.iso"
LOG="build/qemu-debug-serial.log"
OVMF_CODE=""

# Helper untuk mencari firmware UEFI (OVMF)
find_first() {
    for f in "$@"; do
        if [ -f "$f" ]; then
            printf '%s\n' "$f"
            return 0
        fi
    done
    return 1
}

# 2. Deteksi Firmware UEFI
OVMF_CODE="$(find_first \
    /usr/share/OVMF/OVMF_CODE_4M.fd \
    /usr/share/OVMF/OVMF_CODE.fd \
    /usr/share/edk2/ovmf/OVMF_CODE.fd \
    /usr/share/qemu/OVMF_CODE.fd || true)"

# 3. Validasi Prasyarat
if [ ! -f "$ISO" ]; then
    echo "❌ ERROR: ISO tidak ditemukan. Jalankan 'make image' terlebih dahulu."
    exit 1
fi

if [ -z "$OVMF_CODE" ]; then
    echo "❌ ERROR: OVMF_CODE tidak ditemukan. Silakan pasang paket 'ovmf'."
    exit 1
fi

# 4. Eksekusi QEMU dalam Mode Debug
echo "🛠️  Menjalankan QEMU dalam mode DEBUG..."
echo "💡 Menunggu koneksi GDB di port 1234..."
echo "💡 Ketik 'c' di prompt (qemu) atau gunakan GDB untuk memulai eksekusi."

rm -f "$LOG"

qemu-system-x86_64 \
    -machine q35 \
    -cpu qemu64 \
    -m 512M \
    -serial "file:$LOG" \
    -display none \
    -monitor stdio \
    -no-reboot \
    -no-shutdown \
    -drive "if=pflash,format=raw,readonly=on,file=$OVMF_CODE" \
    -cdrom "$ISO" \
    -s -S
