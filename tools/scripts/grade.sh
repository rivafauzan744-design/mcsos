#!/bin/bash

# Warna untuk output terminal
HIJAU='\033[0;32m'
MERAH='\033[0;31m'
KUNING='\033[1;33m'
NORMAL='\033[0m'

echo -e "${KUNING}=======================================${NORMAL}"
echo -e "${KUNING}   MCSOS AUTOGRADER - MILESTONE 1 & 2  ${NORMAL}"
echo -e "${KUNING}=======================================${NORMAL}"

NILAI=0
TOTAL_TEST=4

# 1. Periksa file metadata M1 yang kita buat kemarin
echo -n "Checking Milestone 1 Metadata... "
if [ -f ".mcsos/metadata/m1_done" ]; then
    echo -e "${HIJAU}[OK]${NORMAL}"
    NILAI=$((NILAI + 25))
else
    echo -e "${MERAH}[GAGAL]${NORMAL} (Metadata M1 tidak ditemukan)"
fi

# 2. Periksa struktur folder dasar Milestone 2
echo -n "Checking M2 Folder Structure... "
if [ -d "kernel/core" ] && [ -d "kernel/arch/x86_64" ]; then
    echo -e "${HIJAU}[OK]${NORMAL}"
    NILAI=$((NILAI + 25))
else
    echo -e "${MERAH}[GAGAL]${NORMAL} (Folder kernel belum lengkap)"
fi

# 3. Periksa keberadaan file utama kernel (Poin 19)
echo -n "Checking Kernel Main Source... "
if [ -f "kernel/core/main.c" ] || [ -f "kernel/core/kernel.c" ]; then
    echo -e "${HIJAU}[OK]${NORMAL}"
    NILAI=$((NILAI + 25))
else
    echo -e "${MERAH}[BELUM ADA]${NORMAL} (Silakan lanjut ketik Halaman 43)"
fi

# 4. Jalankan Shellcheck untuk memastikan skrip tools aman
echo -n "Running Shellcheck on tools... "
if shellcheck tools/scripts/*.sh > /dev/null 2>&1; then
    echo -e "${HIJAU}[PASSED]${NORMAL}"
    NILAI=$((NILAI + 25))
else
    echo -e "${KUNING}[WARN]${NORMAL} (Ada skrip yang penulisan sintaksnya kurang rapi)"
    NILAI=$((NILAI + 15))
fi

echo -e "${KUNING}---------------------------------------${NORMAL}"
echo -e "TOTAL NILAI KAMU: ${HIJAU}${NILAI}/100${NORMAL}"
echo -e "${KUNING}=======================================${NORMAL}"
