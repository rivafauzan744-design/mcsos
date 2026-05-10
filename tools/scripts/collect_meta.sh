#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="$ROOT/build/meta"
mkdir -p "$OUT_DIR"
{
    echo "--- MCSOS BUILD METADATA ---"
    echo "timestamp  : $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    check_version() {
        echo -n "$1: "
        "$@" --version 2>/dev/null | head -n 1 || echo "NOT INSTALLED"
    }
    check_version git
    check_version make
    check_version gcc
} > "$OUT_DIR/toolchain-versions.txt"
echo "Metadata berhasil disimpan di: $OUT_DIR"
