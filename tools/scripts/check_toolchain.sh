#!/usr/bin/env bash
set -euo pipefail
# ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATUS=0
check_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        printf "OK: %-20s -> %s\n" "$1" "$(command -v "$1")"
    else
        printf "ERROR: missing %s\n" "$1" >&2
        STATUS=1
    fi
}
echo "Validating Toolchain..."
for cmd in git make gcc nasm qemu-system-x86_64; do check_cmd "$cmd"; done
exit "$STATUS"
