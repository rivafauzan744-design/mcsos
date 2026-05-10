#!/usr/bin/env bash
set -euo pipefail

# 1. Konfigurasi Path
KERNEL="build/kernel.elf"
ISO="build/mcsos.iso"
ISO_ROOT="iso_root"
LIMINE_DIR="third_party/limine"

echo "💿 Memulai proses pembuatan ISO MCSOS..."

# 2. Validasi Prasyarat
if [ ! -f "$KERNEL" ]; then
    echo "❌ ERROR: $KERNEL tidak ditemukan. Jalankan 'make build' terlebih dahulu." >&2
    exit 1
fi

if [ ! -d "$LIMINE_DIR" ]; then
    echo "⚠️  Limine tidak ditemukan, mencoba mengambil..."
    ./tools/scripts/fetch_limine.sh
fi

# 3. Persiapan Struktur Folder ISO (Standar UEFI & BIOS)
echo "Preparing ISO root structure..."
rm -rf "$ISO_ROOT"
mkdir -p "$ISO_ROOT/boot/limine" 
mkdir -p "$ISO_ROOT/EFI/BOOT"
mkdir -p build

# 4. Penyalinan Kernel dan Konfigurasi
cp -v "$KERNEL" "$ISO_ROOT/boot/kernel.elf"
cp -v configs/limine/limine.conf "$ISO_ROOT/boot/limine/limine.conf"

# 5. Penyalinan Artifact Limine (BIOS & UEFI)
echo "Copying Limine artifacts..."
cp -v "$LIMINE_DIR/limine-bios.sys"    "$ISO_ROOT/boot/limine/"
cp -v "$LIMINE_DIR/limine-bios-cd.bin" "$ISO_ROOT/boot/limine/"
cp -v "$LIMINE_DIR/limine-uefi-cd.bin" "$ISO_ROOT/boot/limine/"
cp -v "$LIMINE_DIR/BOOTX64.EFI"        "$ISO_ROOT/EFI/BOOT/BOOTX64.EFI"

# Opsional: Support untuk sistem 32-bit UEFI
if [ -f "$LIMINE_DIR/BOOTIA32.EFI" ]; then
    cp -v "$LIMINE_DIR/BOOTIA32.EFI" "$ISO_ROOT/EFI/BOOT/BOOTIA32.EFI"
fi

# 6. Pembuatan ISO Image menggunakan xorriso
echo "Generating ISO image with xorriso..."
xorriso -as mkisofs \
    -R -r -J \
    -b boot/limine/limine-bios-cd.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    --efi-boot boot/limine/limine-uefi-cd.bin \
    -efi-boot-part --efi-boot-image --protective-msdos-label \
    "$ISO_ROOT" -o "$ISO"

# 7. Instalasi Bootloader Limine untuk mode BIOS
echo "Installing Limine BIOS sectors..."
"$LIMINE_DIR/limine" bios-install "$ISO"

# 8. Verifikasi Akhir
sha256sum "$ISO" | tee build/mcsos.iso.sha256
echo "----------------------------------------"
echo "✅ OK: ISO berhasil dibuat pada $ISO"
echo "----------------------------------------"
