#!/usr/bin/env bash
set -euo pipefail
ISO="build/mcsos.iso"
LOG="build/qemu-serial.log"
OVMF_CODE=$(find /usr/share/OVMF /usr/share/edk2 /usr/share/qemu -name "OVMF_CODE*" -print -quit 2>/dev/null || echo "")

if [ ! -f "$ISO" ]; then exit 1; fi
rm -f "$LOG" && touch "$LOG"

Q_ARGS=(-machine q35 -cpu qemu64 -m 512M -serial "file:$LOG" -display none -monitor none -cdrom "$ISO")
[ -n "$OVMF_CODE" ] && Q_ARGS+=(-drive "if=pflash,format=raw,readonly=on,file=$OVMF_CODE")

echo "🚀 Menjalankan simulasi..."
timeout 10s qemu-system-x86_64 "${Q_ARGS[@]}" || true

# MEMBERSIHKAN LOG (Menghapus karakter \r agar grep lancar)
sed -i 's/\r//g' "$LOG"

echo "📝 Verifikasi Log..."
# Menggunakan pola yang lebih sederhana agar tidak sensitif terhadap spasi tipis
if grep -q 'Milestone 2' "$LOG" && \
   grep -q 'Early serial online' "$LOG" && \
   grep -q 'Kernel entry path entered' "$LOG"; then
    echo "✅ OK: Milestone 2 Valid!"
else
    echo "❌ FAILED: Isi log tidak sesuai harapan."
    echo "--- ISI LOG ASLI ---"
    cat -A "$LOG" # Menampilkan karakter tersembunyi
    echo "--------------------"
    exit 1
fi
