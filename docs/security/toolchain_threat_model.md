# Threat Model Ringkas M1 - Toolchain dan Lingkungan

Dokumen ini mengidentifikasi aset, asumsi kepercayaan, dan ancaman terhadap integritas sistem pembangun (toolchain) MCSOS selama fase Milestone 1.

---

## 💎 Assets (Aset)
1. **Source Code**: Kode sumber utama MCSOS.
2. **Build System**: Script build (`Makefile`) dan script pengujian (`.sh`).
3. **Toolchain**: Compiler (GCC/Clang), Linker (ld.lld), Assembler (NASM), Emulator (QEMU), dan Debugger (GDB).
4. **Generated Artifacts**: Object files (`.o`), executable (`.elf`), log pengujian, dan metadata.
5. **Evidence**: Bukti praktikum dan laporan kesiapan lingkungan.

## 🤝 Trust Assumptions (Asumsi Kepercayaan)
1. Paket OS (Ubuntu/Debian) berasal dari repository resmi atau mirror yang terpercaya.
2. Integritas binary compiler/linker terjaga (tidak dimodifikasi secara manual oleh pihak ketiga).
3. Repositori tersimpan di filesystem native Linux (WSL) untuk menjamin stabilitas *permission* dan *executable bit*.
4. Ruang lingkup risiko M1 terbatas pada salah konfigurasi dan *supply-chain*, karena belum ada eksekusi kode guest.

## ⚠️ Threat Analysis (Analisis Ancaman)

| Threat (Ancaman) | Dampak | Mitigasi M1 |
| :--- | :--- | :--- |
| **Compiler Host Salah Target** | Object file tidak cocok untuk arsitektur kernel. | Inspeksi manual dengan `readelf` dan pengecekan *target triple*. |
| **Ketergantungan Runtime Host** | Kernel bergantung pada libc/startup host yang tidak tersedia saat booting. | Penggunaan flag `-nostdlib`, `-ffreestanding`, dan validasi simbol dengan `nm -u`. |
| **Repository di `/mnt/c`** | Masalah *permission*, *symlink*, dan *case-sensitivity* yang merusak build. | Validasi lokasi path secara otomatis pada script `check_toolchain.sh`. |
| **Artifact Dikomit ke Git** | Repositori menjadi kotor, berat, dan sulit direproduksi. | Implementasi `.gitignore` yang ketat dan prosedur `make distclean`. |
| **OVMF Tidak Tersedia** | Kegagalan booting UEFI pada Milestone 2 (M2). | Pengecekan ketersediaan firmware melalui `qemu_probe.sh`. |
| **Versi Tool Tidak Tercatat** | Build tidak dapat diaudit atau direproduksi di mesin lain. | Pencatatan otomatis versi tool menggunakan `collect_meta.sh`. |

---
