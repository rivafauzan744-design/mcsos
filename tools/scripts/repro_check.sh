#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/build/repro"
PROOF="$ROOT/build/proof/freestanding_probe.elf"

mkdir -p "$OUT"

echo "Mengecek integritas file ELF..."

if [ ! -f "$PROOF" ]; then
    echo "ERROR: File proof tidak ditemukan!"
    exit 1
fi

# Mengambil sha256sum tanpa menjalankan filenya
sha256sum "$PROOF" | tee "$OUT/sha256-check.txt"

echo "OK: Verifikasi integritas selesai."
