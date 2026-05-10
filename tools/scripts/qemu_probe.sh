#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/build/meta"
mkdir -p "$OUT"

{
    echo "[qemu-version]"
    qemu-system-x86_64 --version
    echo
    echo "[ovmf-candidates]"
    for path in /usr/share/OVMF/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE_4M.fd /usr/share/ovmf/OVMF.fd /usr/share/qemu/OVMF.fd; do
        if [ -r "$path" ]; then echo "$path"; fi
    done
} | tee "$OUT/qemu-capabilities.txt"

if ! grep -qi "ovmf" "$OUT/qemu-capabilities.txt"; then
    echo "ERROR: OVMF firmware candidate not found" >&2
    exit 1
fi

echo "OK: QEMU and OVMF probe complete"
