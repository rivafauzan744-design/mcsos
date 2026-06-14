#!/usr/bin/env bash
set -e

KERNEL="build/kernel.elf"
ISO="build/mcsos.iso"
ISO_ROOT="iso_root"
LIMINE_DIR="limine"

echo "[1/8] Memeriksa kernel..."
if [ ! -f "$KERNEL" ]; then
    echo "FAIL: Kernel tidak ditemukan di $KERNEL. Jalankan 'make build' dulu."
    exit 1
fi

echo "[2/8] Mengunduh Limine (jika belum ada)..."
if [ ! -d "$LIMINE_DIR" ]; then
    git clone https://github.com/limine-bootloader/limine.git --branch=v5.x-branch-binary --depth=1 "$LIMINE_DIR"
fi

echo "[3/8] Menyiapkan struktur direktori ISO..."
rm -rf "$ISO_ROOT"
mkdir -p "$ISO_ROOT/boot/limine"

echo "[4/8] Menyalin kernel..."
cp -v "$KERNEL" "$ISO_ROOT/boot/kernel.elf"

echo "[5/8] Membuat file konfigurasi Limine..."
# Menggunakan PROTOCOL=limine. Jika nanti kernel tidak bisa diload, kita ganti multiboot1
echo "TIMEOUT=0

:MCSOS
PROTOCOL=limine
KERNEL_PATH=boot:///kernel.elf" > "$ISO_ROOT/boot/limine/limine.conf"

echo "[6/8] Mencari Limine BOOTX64.EFI..."
EFI_FILE=""
if [ -f "$LIMINE_DIR/BOOTX64.EFI" ]; then
    EFI_FILE="$LIMINE_DIR/BOOTX64.EFI"
elif [ -f "$LIMINE_DIR/bin/BOOTX64.EFI" ]; then
    EFI_FILE="$LIMINE_DIR/bin/BOOTX64.EFI"
else
    echo "FAIL: BOOTX64.EFI tidak ditemukan di folder limine."
    exit 1
fi

echo "[7/8] Membuat EFI System Partition (efi.img)..."
dd if=/dev/zero of=build/efi.img bs=1M count=4 status=none
mkfs.vfat build/efi.img
mmd -i build/efi.img ::EFI
mmd -i build/efi.img ::EFI/BOOT
mmd -i build/efi.img ::boot
mmd -i build/efi.img ::boot/limine
mcopy -i build/efi.img "$EFI_FILE" ::EFI/BOOT/
mcopy -i build/efi.img "$ISO_ROOT/boot/limine/limine.conf" ::boot/limine/

# Sisipkan efi.img ke iso_root agar xorriso bisa membacanya
cp build/efi.img "$ISO_ROOT/efi.img"

echo "[8/8] Mengemas ISO dengan xorriso..."
xorriso -as mkisofs -R -J -e efi.img -no-emul-boot --protective-msdos-label "$ISO_ROOT" -o "$ISO"

echo "PASS: ISO berhasil dibuat di $ISO"
