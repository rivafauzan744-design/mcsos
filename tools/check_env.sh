#!/usr/bin/env bash
set -euo pipefail

# Konfigurasi Path
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
META_DIR="$ROOT_DIR/build/meta"
mkdir -p "$META_DIR"

fail=0

# Fungsi Helper
say() { 
    printf '\n\033[1;34m[M0]\033[0m %s\n' "$*" 
}

check_tool() {
    local tool="$1"
    if command -v "$tool" >/dev/null 2>&1; then
        printf '  \033[0;32m[OK]\033[0m   %-24s %s\n' "$tool" "$(command -v "$tool")"
    else
        printf '  \033[0;31m[FAIL]\033[0m %-24s NOT FOUND\n' "$tool"
        fail=1
    fi
}

# 1. Verifikasi Lokasi Repository (WSL Performance Check)
say "Repository root: $ROOT_DIR"
case "$ROOT_DIR" in
    /mnt/[cdefgh]/*)
        printf '  \033[0;33m[WARN]\033[0m Repository berada di filesystem Windows (/mnt/).\n'
        printf '         Sangat disarankan pindah ke ~/src/ untuk performa dan kompatibilitas.\n'
        ;;
    *)
        printf '  \033[0;32m[OK]\033[0m   Repository berada di native Linux filesystem.\n'
        ;;
esac

# 2. Cek Toolset Wajib
say "Checking required tools..."
TOOLS=(
    git make clang ld.lld llvm-readelf llvm-objdump 
    readelf objdump nasm qemu-system-x86_64 
    gdb python3 shellcheck cppcheck
)

for tool in "${TOOLS[@]}"; do
    check_tool "$tool"
done

# 3. Pembuatan Metadata
say "Writing toolchain metadata..."
{
    echo "=== MCSOS ENVIRONMENT METADATA ==="
    echo "timestamp_utc : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "root_dir      : $ROOT_DIR"
    echo "uname         : $(uname -a)"
    echo "wsl_distro    : ${WSL_DISTRO_NAME:-unknown}"
    echo "shell         : $SHELL"
    echo
    echo "=== TOOL VERSIONS ==="
    git --version || true
    make --version | head -n 1 || true
    clang --version | head -n 1 || true
    ld.lld --version | head -n 1 || true
    llvm-readelf --version | head -n 1 || true
    llvm-objdump --version | head -n 1 || true
    readelf --version | head -n 1 || true
    objdump --version | head -n 1 || true
    nasm -v || true
    qemu-system-x86_64 --version | head -n 1 || true
    gdb --version | head -n 1 || true
    python3 --version || true
    shellcheck --version | grep "version:" || true
    cppcheck --version || true
} > "$META_DIR/toolchain-versions.txt"

printf '  \033[0;32m[DONE]\033[0m Metadata saved to: build/meta/toolchain-versions.txt\n'

# Final Status
if [ "$fail" -ne 0 ]; then
    say "\033[0;31mEnvironment check failed!\033[0m Silakan instal tool yang kurang."
    exit 1
fi

say "Environment check completed. M0 baseline is valid."
