#!/usr/bin/env bash
BUILD_DIR="build"
LOG_FILE="${BUILD_DIR}/m3_serial.log"

echo "[MCSOS M3] Menyinkronkan biner panic ke dalam mode ISO Bootloader..."

# 1. Paksa Makefile menyusun varian panic sebagai biner utama untuk sementara waktu
if [ -f "Makefile" ]; then
    # Menyalin biner panic ke tempat yang biasanya dicari oleh skrip pembuat ISO M2
    mkdir -p iso_root
    cp build/kernel.panic.elf build/kernel.elf 2>/dev/null || true
    
    # Menjalankan perintah pembuatan ISO jika targetnya tersedia di Makefile kamu
    if grep -q "iso" Makefile; then
        echo "[MCSOS M3] Membuat file ISO menggunakan Makefile..."
        make iso >/dev/null 2>&1
    elif [ -f "tools/scripts/m2_iso.sh" ]; then
        echo "[MCSOS M3] Membuat file ISO menggunakan skrip M2..."
        ./tools/scripts/m2_iso.sh >/dev/null 2>&1
    fi
fi

# Pastikan file log bersih
> "$LOG_FILE"

echo "[MCSOS M3] Menjalankan QEMU melalui Emulasi Mesin + Serial Redirect..."
echo "[MCSOS M3] Menunggu output kernel... (Mohon tunggu 4 detik)"

# 2. Jalankan QEMU dengan mengarahkan port serial COM1 ke file log secara interaktif
qemu-system-x86_64 \
    -nographic \
    -display none \
    -serial file:"$LOG_FILE" \
    -kernel build/kernel.panic.elf 2>/dev/null &
QEMU_PID=$!

sleep 4

# 3. Validasi isi Log
if [ -s "$LOG_FILE" ]; then
    echo -e "\n--- [SUKSES] HASIL LOG SERIAL KERNEL ---"
    cat "$LOG_FILE"
    echo -e "-----------------------------------------\n"
    kill $QEMU_PID 2>/dev/null
    exit 0
fi

# Fallback: Jika parameter -kernel gagal total karena pembatasan WSL, pakai file ISO buatan M2
kill $QEMU_PID 2>/dev/null
if [ -f "build/mcsos.iso" ]; then
    echo "[MCSOS M3] Parameter -kernel diblokir host. Mencoba Fallback via mcsos.iso..."
    qemu-system-x86_64 \
        -nographic \
        -display none \
        -serial file:"$LOG_FILE" \
        -cdrom build/mcsos.iso 2>/dev/null &
    QEMU_PID=$!
    sleep 4
fi

# Tampilkan hasil akhir
if [ -s "$LOG_FILE" ]; then
    echo -e "\n--- [SUKSES VIA ISO] HASIL LOG SERIAL KERNEL ---"
    cat "$LOG_FILE"
    echo -e "-------------------------------------------------\n"
else
    echo "ERROR: Kernel tetap tidak menghasilkan log."
    echo "Tips: Pastikan fungsi 'serial_init()' dan 'outb()' di M2 kemarin tidak ada yang terhapus."
fi

# Matikan QEMU
kill $QEMU_PID 2>/dev/null
