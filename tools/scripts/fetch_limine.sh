#!/usr/bin/env bash
set -euo pipefail

# 1. Konfigurasi Path dan Sumber
LIMINE_DIR="third_party/limine"
LIMINE_BRANCH="${LIMINE_BRANCH:-v11.x-binary}"
LIMINE_URL="${LIMINE_URL:-https://github.com/limine-bootloader/limine.git}"

mkdir -p third_party build/meta

echo "🔄 Fetching Limine Bootloader (Branch: $LIMINE_BRANCH)..."

# 2. Clone atau Update Repository
if [ -d "$LIMINE_DIR/.git" ]; then
    echo "Updating existing Limine directory..."
    git -C "$LIMINE_DIR" fetch --depth=1 origin "$LIMINE_BRANCH"
    git -C "$LIMINE_DIR" checkout "$LIMINE_BRANCH"
else
    echo "Cloning Limine from scratch..."
    rm -rf "$LIMINE_DIR"
    git clone "$LIMINE_URL" --branch="$LIMINE_BRANCH" --depth=1 "$LIMINE_DIR"
fi

# 3. Kompilasi Tool Limine (khusus untuk utility 'limine' host)
echo "Building Limine host utilities..."
make -C "$LIMINE_DIR"

# 4. Pencatatan Metadata untuk Audit M2
echo "Saving Limine metadata..."
git -C "$LIMINE_DIR" rev-parse HEAD | tee build/meta/limine-revision.txt
printf 'branch=%s\nurl=%s\n' "$LIMINE_BRANCH" "$LIMINE_URL" | tee -a build/meta/limine-revision.txt

# 5. Verifikasi Keberadaan Komponen Vital
echo "Verifying Limine artifacts..."
test -f "$LIMINE_DIR/limine-bios.sys"
test -f "$LIMINE_DIR/limine-bios-cd.bin"
test -f "$LIMINE_DIR/limine-uefi-cd.bin"
test -f "$LIMINE_DIR/BOOTX64.EFI"

# Cek apakah executable 'limine' sudah siap
if [ -x "$LIMINE_DIR/limine" ] || [ -f "$LIMINE_DIR/limine" ]; then
    echo "✅ OK: Limine ready in $LIMINE_DIR"
else
    echo "❌ ERROR: Limine executable not found!"
    exit 1
fi
