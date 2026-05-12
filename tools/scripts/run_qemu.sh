#!/usr/bin/env bash
set -euo pipefail

ISO="build/mcsos.iso"
LOG="build/qemu-serial.log"
OVMF_CODE=""

find_first() {
    for f in "$@"; do
        if [ -f "$f" ]; then
            printf '%s\n' "$f"
            return 0
        fi
    done
    return 1
}

OVMF_CODE="$(find_first \
    /usr/share/OVMF/OVMF_CODE_4M.fd \
    /usr/share/OVMF/OVMF_CODE.fd \
    /usr/share/edk2/ovmf/OVMF_CODE.fd \
    /usr/share/qemu/OVMF_CODE.fd || true)"

if [ ! -f "$ISO" ]; then exit 1; fi
if [ -z "$OVMF_CODE" ]; then exit 1; fi

rm -f "$LOG"
mkdir -p build

QEMU_ARGS=(
    -machine q35 -cpu qemu64 -m 512M
    -serial "file:$LOG" -display none -monitor none
    -no-reboot -no-shutdown
    -drive "if=pflash,format=raw,readonly=on,file=$OVMF_CODE"
    -cdrom "$ISO"
)

# Perbaikan ShellCheck: variabel status digunakan di baris bawahnya
status=0
timeout 20s qemu-system-x86_64 "${QEMU_ARGS[@]}" || status=$?

if [ "$status" -ne 0 ] && [ "$status" -ne 124 ]; then
    echo "QEMU error with status $status"
    exit "$status"
fi

grep -q 'MCSOS 260502' "$LOG"
grep -q 'Early serial online' "$LOG"
grep -q 'Reached controlled halt loop' "$LOG"

echo "OK: QEMU serial log valid: $LOG"
