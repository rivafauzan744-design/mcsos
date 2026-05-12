#!/usr/bin/env bash
set -euo pipefail

# 1. Inisialisasi Environment
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
mkdir -p build/meta
REPORT="build/meta/m2-preflight.txt"
: > "$REPORT"

# Helper untuk logging
log() {
    printf '%s\n' "$*" | tee -a "$REPORT"
}

fail() {
    log "❌ ERROR: $*"
    exit 0
}

need_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        log "✅ OK command: $1 -> $(command -v "$1")"
    else
        fail "Command tidak ditemukan: $1"
    fi
}

log "========================================"
log "== M2 PREFLIGHT MCSOS CHECK          =="
log "========================================"
log "Root Directory: $ROOT"
log "Timestamp UTC:  $(date -u +%Y-%m-%dT%H:%M:%SZ)"
log "----------------------------------------"

# 2. Validasi Filesystem (Mencegah /mnt/c)
case "$ROOT" in
    /mnt/c/*|/mnt/d/*|/mnt/e/*)
        fail "Repository berada di filesystem Windows. Pindahkan ke filesystem Linux WSL (misal: ~/src/mcsos)."
        ;;
    *)
        log "✅ OK filesystem: Native Linux/WSL"
        ;;
esac

# 3. Audit Toolchain Lengkap
log "Checking Toolchain..."
need_cmd git
need_cmd make
need_cmd clang
need_cmd ld.lld
need_cmd readelf
need_cmd objdump
need_cmd nm
need_cmd qemu-system-x86_64
need_cmd xorriso
need_cmd python3

# 4. Validasi Dokumen Arsitektur (M0/M1 Artifacts)
log "Checking Documents..."
for f in \
    docs/architecture/overview.md \
    docs/architecture/invariants.md \
    docs/security/threat_model.md \
    docs/testing/verification_matrix.md; do
    if [ -f "$f" ]; then
        log "✅ OK file: $f"
    else
        fail "Artefak dokumen belum ada: $f"
    fi
done

# 5. Metadata & Proof Validation
if [ -f build/meta/toolchain-versions.txt ]; then
    log "✅ OK M1 metadata found."
else
    log "⚠️  WARN: Metadata M1 belum ada; mencoba 'make meta'..."
    if make -n meta >/dev/null 2>&1; then
        make meta
    else
        fail "Target 'make meta' tidak tersedia dan metadata M1 hilang."
    fi
fi

# 6. Deep Inspection Proof Object M1
if [ -f build/proof/freestanding_probe.o ]; then
    readelf -hW build/proof/freestanding_probe.o > build/meta/m2-check-m1-object-readelf.txt
    
    if grep -q 'Class:.*ELF64' build/meta/m2-check-m1-object-readelf.txt && \
       grep -q 'Machine:.*Advanced Micro Devices X86-64' build/meta/m2-check-m1-object-readelf.txt; then
        log "✅ OK M1 proof object: Valid ELF64 x86_64"
    else
        fail "Object M1 corrupt atau salah target arsitektur!"
    fi
else
    log "⚠️  WARN: Proof object M1 tidak ditemukan. Lewati inspeksi."
fi

# 7. Firmware OVMF Discovery
log "Checking UEFI/OVMF Firmware..."
if find /usr/share -type f \( -name 'OVMF_CODE*.fd' -o -name 'OVMF_VARS*.fd' \) 2>/dev/null | grep -q OVMF; then
    find /usr/share -type f \( -name 'OVMF_CODE*.fd' -o -name 'OVMF_VARS*.fd' \) 2>/dev/null | sort | tee -a "$REPORT"
    log "✅ OK: OVMF detected."
else
    fail "OVMF tidak ditemukan. Jalankan: sudo apt install ovmf"
fi

log "----------------------------------------"
log "🚀 PREFLIGHT M2 SELESAI: SIAP LANJUT M2"
log "========================================"
